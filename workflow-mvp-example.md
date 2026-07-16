> [!IMPORTANT]
> **HACKATHON TEMPLATE & EXAMPLE**
> This file is a template and abstract example. Update all bracketed placeholders `[...]` with your actual hackathon project details.

# Workflow MVP EXAMPLE

## 1. Mục tiêu MVP

Xây một AI Agent chuyên nhận yêu cầu kế toán–Excel bằng ngôn ngữ tự nhiên, làm rõ tối đa 2–3 câu hỏi, tạo và quản lý các artifact yêu cầu, sau đó sinh file Excel thông qua một Excel Tool Layer có kiểm soát.

Use case đầu tiên:

> Tạo workbook quản lý nhập–xuất–tồn cho công ty thương mại bánh kẹo hoạt động ở miền Bắc và miền Nam, có quản lý theo kho, mã hàng, số lô, ngày sản xuất, hạn sử dụng và cảnh báo hàng sắp hết hạn.

MVP tập trung chứng minh bốn giả thuyết:

1. Supervisor hiểu đúng intent sau tối đa 2–3 câu hỏi.
2. Supervisor phân biệt đúng task đơn giản và task cần review.
3. Spec/Plan có thể chuyển thành tool operations an toàn.
4. Workbook tạo ra có thể được kiểm tra bằng deterministic validation.

---

## 2. Kiến trúc tổng thể

```text
┌───────────────────────────────────────────────────────────┐
│                     Minimal Web UI                        │
│                                                           │
│  Chat                     Sidebar Previewer               │
│  ├─ User messages         ├─ USER_INTENT.md               │
│  ├─ Agent responses       ├─ SPEC.md                      │
│  ├─ Activity timeline     ├─ PLAN.md                      │
│  └─ Approve & Run         ├─ Version history / Diff       │
│                           └─ Generated workbook           │
└───────────────────────┬───────────────────────────────────┘
                        │ SSE / REST
                        ▼
┌───────────────────────────────────────────────────────────┐
│                       FastAPI                             │
│                                                           │
│  Task API · Artifact API · Review API · Event Stream      │
└───────────────────────┬───────────────────────────────────┘
                        ▼
┌───────────────────────────────────────────────────────────┐
│                LangGraph Orchestration                    │
│                                                           │
│  Intake → Memory → Intent → Clarify → Complexity Gate     │
│  → Spec → Plan → Review Interrupt → Execute → Validate    │
└───────────────────────┬───────────────────────────────────┘
                        ▼
┌───────────────────────────────────────────────────────────┐
│        Framework-independent Domain Services              │
│                                                           │
│  IntentService          MemoryService                     │
│  ContextBuilder         ArtifactService                   │
│  ComplexityPolicy       SpecService                       │
│  PlanService            ExcelExecutionService             │
│  ValidationService      DeviationPolicy                   │
└────────────┬──────────────┬──────────────┬─────────────────┘
             │              │              │
             ▼              ▼              ▼
       LLM Providers    PostgreSQL    Excel Tool Layer
       OpenAI           Object Store  openpyxl adapter
       OpenRouter       Checkpoints
             │
             ▼
          Langfuse
```

LangGraph chỉ chịu trách nhiệm về state, branching, interrupt và resume. Các lớp domain không được phụ thuộc trực tiếp vào LangGraph hoặc LangChain message types.

Các interface chính:

```python
IntentClassifier
MemoryRepository
ArtifactRepository
SpecGenerator
PlanGenerator
ExcelToolExecutor
WorkbookValidator
TraceSink
EventPublisher
```

Nhờ đó, orchestration framework có thể được thay thế mà không phải viết lại logic nghiệp vụ.

---

## 3. State machine chính

```text
RECEIVE_TASK
    ↓
CREATE_TASK_AND_TRACE
    ↓
LOAD_RELEVANT_MEMORY
    ↓
CLASSIFY_INTENT
    ↓
IDENTIFY_MISSING_INFORMATION
    ├─ Thiếu thông tin quan trọng
    │      ↓
    │   ASK_CLARIFYING_QUESTION
    │      ↓
    │   tối đa 2–3 câu
    │
    └─ Đủ thông tin hoặc hết số câu hỏi
           ↓
APPLY_EXPLICIT_DEFAULTS
           ↓
WRITE_USER_INTENT
           ↓
ASSESS_COMPLEXITY_AND_RISK
    ├─ SIMPLE
    │      ↓
    │   GENERATE_COMPACT_SPEC_PLAN
    │      ↓
    │   EXECUTE_AUTOMATICALLY
    │
    ├─ BORDERLINE
    │      ↓
    │   ASK_USER_TO_CONFIRM_EXECUTION_MODE
    │
    └─ COMPLEX / HIGH-RISK
           ↓
       GENERATE_SPEC
           ↓
       GENERATE_PLAN
           ↓
       PAUSE_FOR_REVIEW
           ↓
       USER APPROVES
           ↓
COMPILE_EXECUTION_MANIFEST
           ↓
EXECUTE_EXCEL_TOOLS
           ↓
VALIDATE_WORKBOOK
    ├─ PASS → DELIVER
    ├─ RETRYABLE TECHNICAL ERROR → RETRY
    ├─ TECHNICAL DEVIATION → CONTINUE + TRACE
    └─ USER-VISIBLE DEVIATION → PAUSE + REAPPROVAL
           ↓
UPDATE_TASK_MEMORY
           ↓
COLLECT_FEEDBACK
```

---

## 4. Vai trò của các agent

### Supervisor Agent

Supervisor là agent đối thoại chính, chuyên cho yêu cầu kế toán–Excel.

Nhiệm vụ:

* Phân loại intent.
* Xác định dữ liệu còn thiếu.
* Chọn tối đa 2–3 câu hỏi có ảnh hưởng lớn nhất.
* Đưa ra assumption khi người dùng không cung cấp đủ thông tin.
* Tạo `USER_INTENT.md`.
* Phân loại complexity và risk.
* Quyết định `ACT`, `ASK`, `REVIEW_REQUIRED` hoặc `DO_NOT_ACT`.
* Quản lý version của Spec và Plan.
* Phân biệt technical deviation với user-visible deviation.

Supervisor không trực tiếp tạo workbook.

### Spec Agent

Đọc phiên bản mới nhất của:

```text
USER_INTENT.md
Relevant workspace memory
Domain policies
Existing project state
```

Sau đó áp dụng adapter của `to-spec`.

Skill `to-spec` không nên phỏng vấn người dùng mà chỉ tổng hợp những gì đã được thống nhất thành Spec. Vì vậy clarification phải hoàn tất trước khi gọi skill.

### Plan Agent

Chuyển Spec thành hai lớp kế hoạch:

```markdown
# Kế hoạch thực hiện

## 1. Bản kế hoạch dễ hiểu

Nội dung dành cho người không có kiến thức lập trình:
- Workbook sẽ có những sheet nào.
- Mỗi sheet dùng để làm gì.
- Công thức và quy tắc nghiệp vụ chính.
- Những assumption đang được sử dụng.
- Hệ thống sẽ kiểm tra kết quả như thế nào.

## 2. Technical Execution Plan

- Các Excel tool operation.
- Input và output của từng operation.
- Dependency giữa các operation.
- Validation cần chạy.
- Error và retry policy.
```

Phần kỹ thuật được chia thành các vertical slice có thể kiểm tra độc lập. Đây là hướng phân rã mà `to-tickets` khuyến nghị: mỗi slice phải tạo ra một đường đi hoàn chỉnh và có thể demo hoặc xác minh riêng.

### Excel Execution Agent

Agent này không được chạy Python tùy ý trong MVP.

Nó chỉ được:

1. Đọc Spec và Plan đã được phê duyệt.
2. Sinh `EXECUTION_MANIFEST.json`.
3. Gọi các Excel tools nằm trong allowlist.
4. Đọc tool result.
5. Yêu cầu retry hoặc báo deviation.
6. Gửi workbook sang Validator.

---

## 5. LLM routing

```text
Intent classification + clarification
→ OpenAI model được cấu hình theo lựa chọn của dự án

Spec generation + Plan generation + tool planning
→ OpenRouter / DeepSeek model được cấu hình theo lựa chọn của dự án
```

Không hard-code model ID trong domain logic:

```yaml
models:
  intent_classifier: ${INTENT_MODEL_ID}
  clarification_agent: ${CLARIFICATION_MODEL_ID}
  spec_agent: ${SPEC_MODEL_ID}
  plan_agent: ${PLAN_MODEL_ID}
  excel_execution_agent: ${EXECUTION_MODEL_ID}
```

Tên model chính xác cần được kiểm tra lại với provider khi bắt đầu triển khai; workflow không phụ thuộc vào một model ID cố định.

Mỗi model response phải trả về structured output được validate bằng Pydantic hoặc JSON Schema.

---

## 6. Intent contract

Intent Classifier trả về:

```json
{
  "primary_intent": "create_inventory_workbook",
  "secondary_intents": [
    "track_inventory_by_batch",
    "track_expiry"
  ],
  "domain": "commercial_inventory",
  "entities": {
    "industry": "confectionery",
    "regions": ["north_vietnam", "south_vietnam"],
    "company_size": 100,
    "products": [
      "Cơm cháy",
      "Kẹo lạc",
      "Bánh đậu xanh"
    ]
  },
  "required_information": [
    "warehouses",
    "units",
    "expiry_thresholds"
  ],
  "missing_information": [
    "warehouses",
    "units",
    "expiry_thresholds"
  ],
  "risk_flags": [],
  "confidence": 0.86
}
```

Supervisor chọn câu hỏi dựa trên:

```text
Question priority
= ảnh hưởng tới workbook structure
× ảnh hưởng tới business logic
× khả năng giảm ambiguity
```

Với prompt mẫu, ba câu hỏi ưu tiên là:

1. Công ty có bao nhiêu kho và tên từng kho?
2. Mỗi mặt hàng dùng đơn vị gói, hộp, thùng hay nhiều đơn vị quy đổi?
3. Cần cảnh báo trước hạn sử dụng bao nhiêu ngày?

Nếu người dùng không trả lời đủ, dùng default:

```yaml
warehouses:
  - code: KMB01
    name: Kho Miền Bắc
    region: Miền Bắc
  - code: KMN01
    name: Kho Miền Nam
    region: Miền Nam

unit_model: one_primary_unit_per_product

expiry_alerts:
  warning_days: 90
  critical_days: 30
```

Default luôn phải xuất hiện trong UI, `USER_INTENT.md` và trace.

---

## 7. Phân loại simple, borderline và complex

LLM chỉ trích xuất đặc điểm. Quyết định cuối cùng do policy code thực hiện.

### Simple task

Chỉ được auto-execute nếu tất cả điều kiện sau đúng:

* Tạo workbook mới.
* Một nguồn dữ liệu hoặc không có file đầu vào.
* Tối đa ba sheet.
* Không có nhiều thực thể liên kết phức tạp.
* Không có quản lý lô hoặc hạn sử dụng.
* Chỉ dùng công thức phổ biến.
* Không sửa file gốc.
* Không có tax, pháp lý hoặc quyết định kế toán quan trọng.
* Không có external API, Power Query, VBA hoặc macro.
* Có thể kiểm tra hoàn toàn bằng deterministic rules.

Ví dụ:

> Tạo bảng theo dõi chi phí tháng gồm ngày, nội dung, nhóm chi phí, số tiền và tổng theo nhóm.

### Borderline task

* Gần ngưỡng simple.
* Một hoặc hai assumption ảnh hưởng nhẹ.
* Có thể auto-execute nhưng confidence chưa đủ cao.
* Supervisor phải hỏi người dùng có muốn chạy ngay hay review.

### Complex task

Một hard trigger là đủ để chuyển sang review:

* Trên ba sheet.
* Nhiều kho, nhiều bảng hoặc nhiều dimension.
* Theo dõi lô và hạn sử dụng.
* Nhiều nguồn dữ liệu.
* Chỉnh sửa workbook hiện có.
* Dashboard hoặc báo cáo tổng hợp phức tạp.
* Quy tắc kế toán có nhiều cách hiểu.
* Sai sót có thể ảnh hưởng số liệu tài chính.
* Có user-visible assumptions quan trọng.

Prompt quản lý kho bánh kẹo được phân loại:

```yaml
complexity: complex
risk: medium
decision: review_required
reasons:
  - multi_warehouse
  - batch_tracking
  - expiry_tracking
  - more_than_three_sheets
  - linked_business_tables
```

---

## 8. Artifact workflow

Mỗi task có workspace artifact riêng:

```text
/tasks/{task_id}/
├─ USER_INTENT.md
├─ SPEC.md
├─ PLAN.md
├─ EXECUTION_MANIFEST.json
├─ VALIDATION_REPORT.md
├─ artifacts/
│  └─ quan_ly_nhap_xuat_ton_banh_keo.xlsx
└─ metadata.json
```

### `USER_INTENT.md`

```markdown
# User Intent

## Original Request

## Confirmed Goal

## Business Context

## Required Workbook Output

## Clarification Answers

## Assumptions Used

## Complexity and Risk

## Constraints

## Out of Scope

## Confirmation Status
```

### `SPEC.md`

Mở rộng template `to-spec`:

```markdown
# Feature Specification

## Problem Statement
## Solution
## User Stories
## Workbook Output Contract
## Sheet Definitions
## Business Rules
## Assumptions
## Implementation Decisions
## Testing Decisions
## Acceptance Criteria
## Failure Modes
## Out of Scope
## Further Notes
## Good for Later
```

### `PLAN.md`

```markdown
# Execution Plan

## 1. Kế hoạch dễ hiểu

## 2. Workbook Structure

## 3. Quy tắc và công thức chính

## 4. Các bước kiểm tra

---

## 5. Technical Execution Plan

## 6. Tool Operations

## 7. Dependencies

## 8. Retry and Failure Policy
```

### `EXECUTION_MANIFEST.json`

Đây là artifact máy đọc được. Coding Agent không nên dựa hoàn toàn vào prose trong `PLAN.md`.

```json
{
  "spec_version": 2,
  "plan_version": 3,
  "operations": [],
  "validation_rules": [],
  "approved_user_visible_contract_hash": "..."
}
```

---

## 9. Previewer và review flow

Sidebar bên phải hiển thị:

```text
USER_INTENT.md
SPEC.md
PLAN.md
VALIDATION_REPORT.md
Generated XLSX
```

Các nút tối thiểu:

```text
Approve & Run
Request Changes
View Diff
View Assumptions
View Previous Version
```

Người dùng không chỉnh sửa trực tiếp Markdown trong MVP.

Quy trình:

```text
User gửi yêu cầu sửa qua chat
→ Supervisor xác định artifact bị ảnh hưởng
→ Tạo version mới
→ Hiển thị change summary
→ Hiển thị line diff
→ User Approve & Run
```

Các trạng thái artifact:

```text
draft
awaiting_review
changes_requested
approved
superseded
```

Các trạng thái task:

```text
created
clarifying
planning
awaiting_review
approved
executing
validating
completed
failed
paused_for_reapproval
```

---

## 10. Deviation policy

### Technical deviation

Agent có thể tự xử lý nếu không thay đổi kết quả người dùng đã duyệt:

* Thay đổi thứ tự tool call.
* Chia một operation thành nhiều operation.
* Thêm validation.
* Retry với tham số tương đương.
* Chuẩn hóa identifier kỹ thuật.
* Thay đổi implementation nội bộ.

```text
Decision: CONTINUE
Reapproval required: false
Trace event: TECHNICAL_DEVIATION
```

### User-visible deviation

Bắt buộc pause:

* Thêm, xóa hoặc đổi tên sheet.
* Thêm hoặc bỏ cột mà người dùng nhìn thấy.
* Thay đổi công thức nghiệp vụ.
* Thay đổi logic nhập–xuất–tồn.
* Thay đổi ngưỡng cảnh báo.
* Thay assumption.
* Thay nguồn dữ liệu.
* Thay phạm vi báo cáo.

```text
Decision: PAUSE_FOR_REAPPROVAL
→ SPEC/PLAN version mới
→ Hiển thị diff
→ User Approve
→ Resume từ checkpoint
```

---

## 11. Excel Tool Layer cho MVP

Các tools nên là business building blocks, không phải thao tác từng cell.

```text
1. create_workbook
2. create_table_sheet
3. create_master_data_table
4. create_transaction_table
5. add_reference_dropdown
6. add_field_validation
7. add_lookup_column
8. add_calculated_column
9. build_inventory_balance_by_lot
10. build_expiry_alerts
11. build_summary_report
12. apply_standard_formatting
13. protect_calculated_columns
14. validate_and_export_workbook
```

Mỗi tool có:

```yaml
name:
version:
input_schema:
output_schema:
allowed_side_effects:
user_visible_effects:
validation:
idempotency_key:
```

Ví dụ execution operation:

```json
{
  "operation_id": "op_08",
  "tool": "build_inventory_balance_by_lot",
  "arguments": {
    "item_key": "Mã hàng",
    "warehouse_key": "Mã kho",
    "batch_key": "Số lô",
    "inbound_table": "NhapKho",
    "outbound_table": "XuatKho",
    "output_sheet": "TonKho_TheoLo"
  },
  "depends_on": ["op_03", "op_04"],
  "user_visible": true
}
```

Underlying implementation có thể dùng `openpyxl`, nhưng thư viện này nằm sau tool adapter. Agent không được truy cập trực tiếp.

---

## 12. Workbook contract cho use case mẫu

Workbook đề xuất có bảy sheet:

```text
1. DM_HangHoa
2. DM_Kho
3. NhapKho
4. XuatKho
5. TonKho_TheoLo
6. CanhBao_HSD
7. BaoCao_TongHop
```

### DM_HangHoa

```text
Mã hàng
Tên hàng
Nhóm hàng
Đơn vị tính
Hạn sử dụng tiêu chuẩn
Trạng thái
```

Dữ liệu mẫu:

```text
HH001 | Cơm cháy       | Đồ ăn vặt       | Gói
HH002 | Kẹo lạc        | Kẹo truyền thống| Hộp
HH003 | Bánh đậu xanh  | Bánh truyền thống| Hộp
HH004 | Kẹo dừa        | Kẹo             | Gói
HH005 | Bánh pía       | Bánh            | Hộp
```

### DM_Kho

```text
Mã kho
Tên kho
Miền
Tỉnh/Thành
Trạng thái
```

### NhapKho

```text
Ngày nhập
Số phiếu nhập
Mã kho
Mã hàng
Tên hàng
Số lô
Ngày sản xuất
Hạn sử dụng
Đơn vị tính
Số lượng nhập
Đơn giá nhập
Thành tiền
Nhà cung cấp
Người nhập
Ghi chú
```

### XuatKho

```text
Ngày xuất
Số phiếu xuất
Mã kho
Mã hàng
Tên hàng
Số lô
Đơn vị tính
Số lượng xuất
Đơn giá xuất
Thành tiền
Đơn vị nhận
Người xuất
Khu vực
Ghi chú
```

### TonKho_TheoLo

```text
Mã kho
Mã hàng
Tên hàng
Số lô
Ngày sản xuất
Hạn sử dụng
Tổng nhập
Tổng xuất
Tồn hiện tại
Số ngày còn hạn
Trạng thái hạn sử dụng
```

### CanhBao_HSD

```text
Kho
Mã hàng
Tên hàng
Số lô
Hạn sử dụng
Số ngày còn hạn
Số lượng tồn
Mức cảnh báo
```

Mức cảnh báo mặc định:

```text
Đã hết hạn       → <= 0 ngày
Đỏ               → 1–30 ngày
Vàng             → 31–90 ngày
Bình thường       → trên 90 ngày
```

### BaoCao_TongHop

* Tồn kho theo miền.
* Tồn kho theo kho.
* Tồn theo nhóm hàng.
* Hàng sắp hết hạn.
* Hàng đã hết hạn nhưng còn tồn.
* Mặt hàng xuất nhiều.
* Tổng nhập và tổng xuất trong kỳ.

---

## 13. Workbook validation

Các tiêu chí xác định được phải dùng code, không dùng LLM judge. Tài liệu eval cũng khuyến nghị code-based checks cho schema, format, tool usage, data correctness và business invariants; human hoặc model judge chỉ dành cho tiêu chí cần judgment. 

### Blocking validation

```text
Workbook mở được
Required sheets tồn tại
Required columns tồn tại
Không có broken formula reference
Dropdown source tồn tại
Mã hàng và mã kho tham chiếu hợp lệ
Số lượng nhập/xuất không âm
Ngày sản xuất không sau hạn sử dụng
Hạn sử dụng bắt buộc khi có số lô
Tồn = tổng nhập - tổng xuất
Không ghi đè file nguồn
Output file được tạo đúng thư mục
```

### Warning validation

```text
Tồn âm
Số phiếu trùng
Số lô trùng bất thường
Hàng hết hạn nhưng vẫn còn tồn
Hạn sử dụng trước ngày nhập
Mặt hàng chưa có đơn vị tính
Kho chưa có miền
```

### Retry policy

```text
Tool schema error             → không retry, quay lại planner
Transient tool error          → retry tối đa 2 lần
Workbook serialization error  → retry 1 lần
Validation business failure   → không tự sửa nếu user-visible
Unknown error                 → fail gracefully
```

---

## 14. Persistent Memory

### User Preference Memory

```yaml
language: Vietnamese
currency: VND
date_format: dd/mm/yyyy
number_format: "#,##0"
preferred_workbook_style: clean_professional
```

### Accounting Workspace Memory

```yaml
company_name:
warehouse_names:
region_names:
department_names:
product_code_convention:
default_expiry_thresholds:
preferred_sheet_names:
approved_templates:
```

### Task/Episodic Memory

Chỉ lưu:

```text
Task summary
Confirmed intent
Complexity/risk
Approved Spec/Plan versions
Artifact metadata
Validation outcome
User corrections
Important reusable lesson
```

Không lưu:

```text
Raw transaction rows
Full workbook content
Bank account details
Detailed balances
Tax identifiers
Raw sensitive conversation
```

Thứ tự ưu tiên context:

```text
Current explicit user instruction
> Current uploaded source file
> Approved USER_INTENT.md
> Approved SPEC.md
> Approved PLAN.md
> Workspace memory
> User preference memory
> Historical task memory
```

Memory write flow:

```text
Conversation
→ Extract candidate memories
→ Scope classification
→ Sensitive-data filter
→ Conflict and duplicate check
→ Persist
```

---

## 15. Context management

Không gửi toàn bộ conversation và memory vào mọi model call.

Mỗi graph node nhận một `ContextPack` riêng:

```yaml
system_policy:
current_task:
recent_relevant_messages:
latest_user_intent:
approved_artifacts:
relevant_memories:
allowed_tools:
output_schema:
token_budget:
```

Quy tắc:

* Intent node không cần full Spec.
* Spec node không cần toàn bộ tool schema.
* Plan node chỉ nhận tools liên quan.
* Execution node chỉ nhận approved contract và execution manifest.
* Validation node không nhận raw conversation.
* Artifact content được tham chiếu theo version, không copy lặp lại.
* Summarize tại các milestone: intent confirmed, spec approved, execution completed.

---

## 16. Structured Activity Trace

Trace trên UI không hiển thị raw chain-of-thought.

Nó hiển thị:

```text
Agent/state
Action
Input summary
Decision
Short decision reason
Model and prompt version
Tool name
Tool arguments
Tool result summary
Artifacts created or changed
Validation result
Deviation
Latency
Token usage
Cost
Timestamp
```

Một trace hoàn chỉnh cần bao gồm input, instruction/config, context, model calls, tool usage, intermediate steps, final result, metadata và feedback. Đây cũng là cấu trúc trace được mô tả trong tài liệu AI Evaluation. 

Ví dụ:

```text
[Supervisor]
State: ASSESS_COMPLEXITY
Decision: REVIEW_REQUIRED
Reason: Multi-warehouse, batch tracking and expiry rules

[Spec Agent]
Input: USER_INTENT.md v2
Output: SPEC.md v1
Prompt version: accounting-spec-v1

[User Review]
Action: Request Changes
Request: Add expiry warning by warehouse

[Spec Agent]
Output: SPEC.md v2
Diff: Added CanhBao_HSD sheet

[Excel Agent]
Tool: build_inventory_balance_by_lot
Result: SUCCESS
Latency: 340 ms

[Validator]
Inventory reconciliation: PASS
Expiry rules: PASS
Negative stock: WARNING — 2 rows
```

### Langfuse integration

Langfuse lưu developer trace:

```text
Root trace: task
├─ memory retrieval span
├─ intent generation
├─ clarification generations
├─ spec generation
├─ plan generation
├─ review interrupt
├─ tool execution spans
├─ validation spans
└─ final delivery
```

App UI không nên đọc trực tiếp từ Langfuse. Backend ghi normalized events vào `agent_events` để streaming và lưu operational state; đồng thời mirror observability data sang Langfuse.

Prompt và tool payload phải được redaction trước khi gửi Langfuse nếu chứa dữ liệu kế toán nhạy cảm.

---

## 17. Tech stack MVP

```yaml
frontend:
  framework: Next.js / React
  functions:
    - chat
    - SSE activity stream
    - Markdown preview
    - artifact version diff
    - approve and request changes

backend:
  framework: FastAPI
  validation: Pydantic
  streaming: Server-Sent Events

orchestration:
  framework: LangGraph
  persistence: PostgreSQL checkpointer

database:
  primary: PostgreSQL
  usage:
    - tasks
    - graph checkpoints
    - memory
    - artifact metadata
    - review versions
    - agent events
    - eval cases and results

artifact_storage:
  development: local filesystem
  deployment: S3-compatible object storage

excel:
  engine: openpyxl
  access: only through Excel Tool Layer

observability:
  platform: Langfuse

llm:
  providers:
    - OpenAI
    - OpenRouter
  model_ids: environment configuration
```

Redis, vector database, Kafka và Kubernetes chưa cần cho MVP.

---

## 18. Eval plan ban đầu

Bắt đầu bằng 10–30 scenario đa dạng, đọc trace thủ công, ghi failure mode và chọn golden outputs trước khi xây eval phức tạp. Cách tiếp cận này phù hợp với lifecycle vibe check → offline eval → production monitoring. 

### Scenario groups

```text
Simple workbook
Ambiguous request
Missing warehouse information
Multiple warehouses
Batch without expiry date
Expiry date before manufacturing date
Negative inventory
Duplicate document number
Unsupported FIFO request
Modify existing workbook
Tool failure
User-visible deviation
Memory conflict
Incorrect auto-execute decision
```

### Failure taxonomy v0

```text
wrong_intent
missed_intent
ambiguity_not_handled
too_many_questions
assumption_not_disclosed
false_simple_classification
unnecessary_review
wrong_tool
missing_tool_call
invalid_tool_arguments
tool_result_ignored
invalid_workbook
broken_formula
wrong_inventory_balance
invalid_expiry_rule
user_visible_deviation_not_escalated
sensitive_data_persisted
high_latency
high_cost
```

### Release gates v0

```yaml
block_if:
  workbook_open_rate: "< 1.00"
  required_sheet_pass_rate: "< 1.00"
  required_column_pass_rate: "< 1.00"
  false_auto_execute_on_high_risk_cases: "> 0"
  undisclosed_assumptions: "> 0"
  p0_failures: "> 0"
  formula_reconciliation_rate: "< 0.95"

warn_if:
  average_clarification_questions: "> 3"
  simple_task_review_rate: "> 0.20"
  retry_rate: "> 0.15"
  average_latency_seconds: "> target"
  average_cost_usd: "> budget"
```

---

## 19. Implementation roadmap theo vertical slices

### Ticket 1 — Task lifecycle và trace skeleton

Tạo task, graph state, checkpoint, event streaming và root Langfuse trace.

Không có blocker.

### Ticket 2 — Intent clarification và `USER_INTENT.md`

Intent schema, tối đa ba câu hỏi, default assumptions và artifact generation.

Blocked by Ticket 1.

### Ticket 3 — Persistent memory và context packs

Ba lớp memory, precedence, filtering và node-specific context.

Blocked by Ticket 1 và 2.

### Ticket 4 — Spec/Plan generation

Adapter cho `to-spec`, plan hai lớp, versioning và artifact diff.

Blocked by Ticket 2.

### Ticket 5 — Review interrupt

Sidebar previewer, Request Changes, version history, Approve & Run và resume graph.

Blocked by Ticket 4.

### Ticket 6 — Excel Tool Layer

Tool schemas, openpyxl adapters và execution manifest.

Blocked by Ticket 4.

### Ticket 7 — Inventory workbook vertical slice

Tạo đầy đủ workbook bánh kẹo từ intent đã duyệt đến file XLSX.

Blocked by Ticket 5 và 6.

### Ticket 8 — Validation và deviation policy

Deterministic checks, retry, technical deviation và pause khi user-visible deviation.

Blocked by Ticket 7.

### Ticket 9 — Eval harness

Golden scenarios, failure taxonomy, release gate và Langfuse evaluation metadata.

Blocked by Ticket 8.

---

## 20. Good for Later

* **Python sandbox fallback** khi Excel Tool Layer không biểu diễn được yêu cầu.
* Static code scanning, network isolation, resource limit và file-system allowlist cho sandbox.
* FIFO, bình quân gia quyền và tính giá vốn.
* Chuyển kho, kiểm kê và điều chỉnh tồn.
* Nhiều đơn vị tính và quy đổi hộp–thùng–gói.
* Chỉnh sửa workbook trực tiếp trong previewer.
* Power Query, VBA và macro.
* Import nhiều file và tự suy luận schema.
* ERP, Google Drive, email và accounting-software connectors.
* Role-based access control.
* Semantic memory với pgvector.
* LLM-as-judge sau khi có human-labeled calibration set.
* Collaborative review nhiều người.
* Workbook visual preview trước khi tải xuống.
* Template marketplace cho các ngành hàng khác.

Đây là scope đủ nhỏ để xây MVP thực tế, nhưng vẫn kiểm chứng được toàn bộ chuỗi giá trị cốt lõi: **hiểu yêu cầu → làm rõ → ghi intent → tạo Spec/Plan → human review có kiểm soát → thực thi bằng tools → validate → trace → ghi nhớ**.
