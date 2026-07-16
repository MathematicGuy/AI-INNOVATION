# Milestone roadmap đề xuất

```text
M0 — Validate hypothesis
          ↓ GO
M1 — Deterministic Excel Engine
          ├─────────────┐
          ↓             ↓
M2 — Supervisor      M1 và M2 có thể chạy song song
          ↓             │
M3 — Spec/Plan Review   │
          └──────┬──────┘
                 ↓
M4 — End-to-End MVP Alpha
                 ↓
M5 — Trustworthy MVP Pilot
                 ↓
M6 — Generalized Cowork Platform
     Good for Later
```

## Milestone 0 — Evidence Gate

**Mục tiêu:** Xác nhận đây là vấn đề đáng xây trước khi đầu tư vào kiến trúc agent.

**Câu hỏi cần trả lời:**

* Người dùng kế toán/kho có muốn giao task Excel cho AI không?
* Hai đến ba câu hỏi làm rõ có đủ không?
* Người dùng non-dev có hiểu và tin Spec/Plan không?
* Workbook được tạo có đủ giá trị để họ sử dụng hoặc sửa tiếp không?

**Phạm vi:**

* Concierge/Wizard-of-Oz.
* Mock Spec/Plan preview.
* Hard-coded Excel Tool Harness.
* 5–8 phiên test với kế toán, kho vận, vận hành hoặc mentor nghiệp vụ.

**Không xây:**

* LangGraph.
* Database.
* Persistent memory.
* Langfuse UI.
* Agent execution động.

**Exit criteria:**

* Ít nhất 60% người test nói sẽ dùng lại.
* Ít nhất 50% cho rằng giải pháp tiết kiệm thời gian.
* Trung bình không quá 3 câu hỏi làm rõ.
* Ít nhất 70% hiểu đúng phần Plan dành cho non-dev.
* Harness tạo đủ 7 sheet.
* Workbook mở được 100%.
* Validation bắt được tồn âm, hạn sử dụng sai và tham chiếu không hợp lệ.

**Quyết định cuối milestone:**

```text
GO      → tiếp tục M1 và M2
PIVOT   → thu hẹp use case hoặc chuyển template-first
STOP    → quay lại problem discovery
```

Thời lượng dự kiến: **3–5 ngày**.

---

## Milestone 1 — Deterministic Excel Engine V0

**Mục tiêu:** Chứng minh hệ thống có thể tạo workbook đúng mà chưa cần agent.

Đây nên là milestone kỹ thuật đầu tiên. Nó xử lý rủi ro feasibility và reliability trước orchestration.

### Input

Một `EXECUTION_MANIFEST.json` cố định:

```json
{
  "workbook_type": "inventory_by_lot",
  "warehouses": [
    {"code": "KMB01", "name": "Kho Miền Bắc"},
    {"code": "KMN01", "name": "Kho Miền Nam"}
  ],
  "expiry_warning_days": 90,
  "expiry_critical_days": 30
}
```

### Output

Workbook gồm:

1. `DM_HangHoa`
2. `DM_Kho`
3. `NhapKho`
4. `XuatKho`
5. `TonKho_TheoLo`
6. `CanhBao_HSD`
7. `BaoCao_TongHop`

### Build scope

* Excel Tool Layer bằng `openpyxl`.
* Một schema cho execution manifest.
* Tool functions cho bảng danh mục, giao dịch, tồn theo lô, cảnh báo và báo cáo.
* `VALIDATION_REPORT.md`.
* CLI hoặc endpoint nội bộ: manifest → XLSX.

### Không xây

* LLM.
* Chat UI.
* Supervisor.
* Spec/Plan.
* LangGraph.
* Memory.

### Definition of Done

* 10 manifest test tạo file thành công.
* Workbook mở được 100%.
* Đủ sheet và cột bắt buộc.
* Dropdown và lookup hợp lệ.
* `Tồn = Tổng nhập - Tổng xuất`.
* Cảnh báo đỏ/vàng đúng ngưỡng.
* Không ghi đè file đầu vào.
* Validation trả rõ `PASS`, `WARNING`, `BLOCKED`.

**Demo milestone:**

```text
JSON Manifest
→ Excel Tool Layer
→ inventory.xlsx
→ Validation Report
```

Thời lượng dự kiến: **5–7 ngày**.

---

## Milestone 2 — Supervisor Intent V0

**Mục tiêu:** Chứng minh AI hiểu yêu cầu và chỉ hỏi những câu có giá trị cao.

### Input

Prompt tự nhiên:

> Tạo workbook nhập–xuất–tồn cho công ty bánh kẹo hoạt động tại miền Bắc và miền Nam...

### Output

* Intent có structured schema.
* Tối đa 2–3 câu hỏi.
* Assumptions rõ ràng.
* `USER_INTENT.md`.
* Complexity decision: `SIMPLE`, `BORDERLINE` hoặc `COMPLEX`.

### Build scope

* Intent Classifier.
* Missing-information detector.
* Question selector.
* Default assumptions.
* Pydantic validation.
* Complexity/risk policy bằng code.
* Chat hoặc CLI tối giản.

### Không xây

* Spec/Plan.
* Workbook execution.
* Artifact previewer.
* Memory đầy đủ.

### Definition of Done

Chạy tối thiểu 20 scenario:

* Prompt rõ.
* Prompt mơ hồ.
* Thiếu tên kho.
* Thiếu đơn vị tính.
* Thiếu ngưỡng cảnh báo.
* Yêu cầu FIFO ngoài scope.
* Yêu cầu sửa workbook hiện có.
* Task đơn giản.
* Task phức tạp.

Các gate:

* Không quá 3 câu hỏi.
* Không có assumption ẩn.
* Không phân loại `SIMPLE` cho case rủi ro cao.
* `USER_INTENT.md` phản ánh đúng yêu cầu trong ít nhất 80% case do human review.
* Structured output hợp lệ 100%.

**Demo milestone:**

```text
Natural-language request
→ 2–3 clarification questions
→ USER_INTENT.md
→ COMPLEX / REVIEW_REQUIRED
```

Thời lượng dự kiến: **4–6 ngày**.

M1 và M2 có thể phát triển song song.

---

## Milestone 3 — Reviewable Spec/Plan V0

**Mục tiêu:** Chứng minh người dùng non-dev có thể hiểu, chỉnh sửa và duyệt kế hoạch trước execution.

### Build scope

* `USER_INTENT.md` → `SPEC.md`.
* `SPEC.md` → `PLAN.md`.
* Phần non-dev ở đầu Plan.
* Phần technical execution plan ở dưới.
* Sidebar previewer cơ bản.
* `Approve & Run`.
* `Request Changes`.
* Version history tối thiểu.
* Text diff giữa hai version.
* Assumption view.

### Chưa cần

* Rich Markdown editor.
* Multi-user collaboration.
* Comment theo từng dòng.
* Complex branching.
* Workbook visual preview.

### Definition of Done

* Người dùng chỉ ra được workbook sẽ có những sheet nào.
* Người dùng hiểu được assumption đang áp dụng.
* Ít nhất 70% reviewer hiểu đúng nội dung Plan.
* Yêu cầu sửa qua chat tạo được version mới.
* Diff hiển thị đúng thay đổi.
* Chỉ version đã approve mới được đánh dấu executable.
* Tạo được `approved_user_visible_contract_hash`.

**Demo milestone:**

```text
USER_INTENT.md
→ SPEC.md v1
→ PLAN.md v1
→ Request Changes
→ PLAN.md v2 + Diff
→ Approve
```

Thời lượng dự kiến: **5–7 ngày**.

---

## Milestone 4 — End-to-End MVP Alpha

**Mục tiêu:** Hoàn thành thin vertical slice đầu tiên từ prompt đến file Excel.

Đây là thời điểm LangGraph được đưa vào, không phải Milestone 1.

### Workflow

```text
User request
→ Clarification
→ USER_INTENT.md
→ SPEC.md
→ PLAN.md
→ User approval
→ EXECUTION_MANIFEST.json
→ Excel Tool Layer
→ Validation
→ Download XLSX
```

### Build scope

* FastAPI task API.
* LangGraph orchestration tối giản.
* State và checkpoint.
* Pause tại review.
* Resume sau approval.
* Artifact storage local.
* Excel execution.
* Validation.
* Basic Structured Activity Trace.
* Minimal chat + sidebar UI.

### Trace tối thiểu

```text
Task received
Intent detected
Clarification asked
Assumptions applied
Spec created
Plan created
User approved
Manifest compiled
Excel tool called
Validation completed
Artifact delivered
```

### Chưa cần

* Full three-layer semantic memory.
* Advanced Langfuse dashboards.
* S3.
* Multi-user.
* Python sandbox.
* LLM-as-judge.
* Generic Excel use cases.

### Definition of Done

* 10 end-to-end runs thành công liên tiếp.
* Pause và resume đúng sau approval.
* Không execution khi artifact chưa được approve.
* Manifest luôn tham chiếu đúng version Spec/Plan.
* Workbook và validation report tải được.
* Technical deviation được log.
* User-visible deviation gây pause.
* Không ghi đè source file.
* Lỗi được trả về theo trạng thái rõ ràng, không làm graph treo.

**Demo milestone:**

> Người dùng nhập prompt tiếng Việt, trả lời ba câu hỏi, duyệt Plan và nhận workbook nhập–xuất–tồn đã validation.

Thời lượng dự kiến: **7–10 ngày**.

Đây là **MVP có thể demo**.

---

## Milestone 5 — Trustworthy MVP Pilot

**Mục tiêu:** Chuyển từ demo kỹ thuật sang MVP có thể thử với người dùng thật.

### Build scope

* Langfuse tracing cho từng model/tool span.
* Normalized `agent_events` cho UI.
* Redaction dữ liệu nhạy cảm.
* Eval dataset 20–30 scenario.
* Failure taxonomy v0.
* Release gates.
* Feedback sau khi tải workbook.
* Persistent memory tối thiểu:

  * User preferences.
  * Workspace defaults.
  * Task summary và artifact metadata.
* Deviation policy hoàn chỉnh.
* Retry policy.
* Basic cost/latency monitoring.

### Memory chưa cần phức tạp

Không cần vector search hoặc semantic memory. Có thể dùng PostgreSQL records theo key:

```text
user_preferences
workspace_defaults
task_summaries
artifact_metadata
```

### Definition of Done

* Không có P0 failure.
* Workbook open rate 100%.
* Required sheet/column pass rate 100%.
* Formula reconciliation ít nhất 95%.
* Không có assumption bị ẩn.
* Không auto-execute high-risk task.
* Không lưu transaction rows vào persistent memory.
* Trace đủ để xác định lỗi bắt đầu từ intent, planning, tool hay validation.
* Thử nghiệm với 3–5 người dùng.
* Ít nhất 60% muốn dùng lại hoặc thử với task khác.

Thời lượng dự kiến: **5–7 ngày**.

Đây là **MVP có thể pilot**.

---

## Milestone 6 — Generalized Excel Cowork

Milestone này nằm ngoài MVP hiện tại.

Chỉ bắt đầu sau khi pilot cho thấy người dùng có nhu cầu thật.

Phạm vi có thể gồm:

* Python sandbox fallback.
* Nhiều loại workbook: chi phí, công nợ, ngân sách.
* FIFO và tính giá vốn.
* Chuyển kho, kiểm kê và điều chỉnh tồn.
* Import workbook hiện có.
* Nhiều đơn vị quy đổi.
* ERP và phần mềm kế toán connectors.
* Full three-layer semantic memory.
* Artifact editor nâng cao.
* Multi-user review.
* Template marketplace.

---

# Mapping từ tickets hiện tại sang milestones

| Milestone               | Tickets hiện tại                                 |
| ----------------------- | ------------------------------------------------ |
| M0 — Evidence Gate      | Prototype ngoài engineering roadmap              |
| M1 — Excel Engine       | Ticket 6 + một phần Ticket 7 và 8                |
| M2 — Supervisor Intent  | Ticket 2 + phần tối thiểu của Ticket 1           |
| M3 — Spec/Plan Review   | Ticket 4 + Ticket 5                              |
| M4 — End-to-End Alpha   | Ticket 1 + Ticket 7 + integration của 2, 4, 5, 6 |
| M5 — Trustworthy Pilot  | Ticket 3 + Ticket 8 + Ticket 9 + Langfuse        |
| M6 — Generalized Cowork | Các mục Good for Later                           |

# Thay đổi quan trọng so với roadmap cũ

Roadmap hiện tại bắt đầu bằng:

```text
Task lifecycle
→ Trace skeleton
→ Memory
→ Spec/Plan
→ Excel Tool Layer
```

Tôi khuyến nghị đổi thành:

```text
Excel output feasibility
→ Intent understanding
→ Human review
→ End-to-end orchestration
→ Memory, tracing và eval hardening
```

Lý do: rủi ro lớn nhất không phải “LangGraph có chạy không”, mà là:

1. Người dùng có thật sự cần sản phẩm không.
2. Tool Layer có tạo được workbook đủ tốt không.
3. Người dùng có hiểu và duyệt được Plan không.
4. Validation có đủ đáng tin không.

Chỉ khi bốn điểm này có evidence, việc đầu tư vào orchestration, persistence và memory mới hợp lý.

# Timeline tổng hợp

Với một AI/backend engineer và hỗ trợ frontend nhẹ:

```text
Tuần 0     M0 — Prototype evidence
Tuần 1     M1 — Excel Engine
Tuần 2     M2 — Supervisor Intent
Tuần 3     M3 — Spec/Plan Review
Tuần 4–5   M4 — End-to-End Alpha
Tuần 6     M5 — Pilot hardening
```

Ước tính thực tế: **5–7 tuần sau khi Prototype Gate được thông qua**.

Mốc quản trị quan trọng nhất:

* **M1:** chứng minh tạo được Excel.
* **M3:** chứng minh user hiểu và duyệt được.
* **M4:** chứng minh workflow hoàn chỉnh chạy được.
* **M5:** chứng minh đủ tin cậy để pilot.
