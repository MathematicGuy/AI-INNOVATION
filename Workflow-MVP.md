# Workflow MVP [Tên Dự Án] (Core Source of Truth)

> [!IMPORTANT]
> **HACKATHON TEMPLATE & EXAMPLE**
> This file is a template and abstract example. Update all bracketed placeholders `[...]` with your actual hackathon project details.

## 1. Mục tiêu MVP
Xây một AI Agent chuyên nhận yêu cầu [Nghiệp Vụ] bằng ngôn ngữ tự nhiên, làm rõ tối đa 2–3 câu hỏi, tạo và quản lý các artifact yêu cầu, sau đó thực thi thông qua một Tool Layer có kiểm soát.

MVP tập trung chứng minh bốn giả thuyết:
1. Supervisor hiểu đúng intent sau tối đa 2–3 câu hỏi.
2. Supervisor phân biệt đúng task đơn giản (auto-execute) và task cần review.
3. Spec/Plan có thể chuyển thành tool operations an toàn.
4. Đầu ra tạo ra có thể được kiểm tra bằng deterministic validation.

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
│  └─ Approve & Run         └─ Output Preview               │
└───────────────────────┬───────────────────────────────────┘
                        │ SSE / REST
                        ▼
┌───────────────────────────────────────────────────────────┐
│                       FastAPI                             │
│  Task API · Artifact API · Review API · Event Stream      │
└───────────────────────┬───────────────────────────────────┘
                        ▼
┌───────────────────────────────────────────────────────────┐
│                LangGraph Orchestration                    │
│  Intake → Memory → Intent → Clarify → Complexity Gate     │
│  → Spec → Plan → Review Interrupt → Execute → Validate    │
└───────────────────────┬───────────────────────────────────┘
                        ▼
┌───────────────────────────────────────────────────────────┐
│        Framework-independent Domain Services              │
│  IntentService          MemoryService                     │
│  ContextBuilder         ArtifactService                   │
│  ComplexityPolicy       SpecService                       │
│  PlanService            ExecutionService                  │
│  ValidationService      DeviationPolicy                   │
└───────────────────────────────────────────────────────────┘
```

---

## 3. State machine chính
1. **RECEIVE_TASK** -> Tạo task và trace.
2. **LOAD_RELEVANT_MEMORY** -> Tải ngữ cảnh/quy ước cũ.
3. **CLASSIFY_INTENT** -> Trích xuất intent và trích xuất tham số.
4. **IDENTIFY_MISSING_INFORMATION** -> Nếu thiếu, sinh câu hỏi làm rõ (tối đa 2-3 câu). Nếu đủ, viết `USER_INTENT.md`.
5. **ASSESS_COMPLEXITY_AND_RISK** -> Phân nhánh:
   - **SIMPLE:** Tự động tạo Spec/Plan và Auto-execute.
   - **COMPLEX:** Tạo Spec/Plan -> Dừng chờ phê duyệt (PAUSE_FOR_REVIEW).
6. **COMPILE_EXECUTION_MANIFEST** -> Dịch plan thành tệp cấu hình cho máy đọc.
7. **EXECUTE_TOOLS** -> Gọi Tool Layer kiểm soát.
8. **VALIDATE_OUTPUT** -> Kiểm thử đầu ra bằng code (PASS | RETRY | PAUSE_FOR_REAPPROVAL).
9. **UPDATE_MEMORY** -> Lưu kinh nghiệm và phản hồi.

---

## 4. Vai trò của các agent
- **Supervisor Agent:** Phân loại intent, phát hiện thông tin thiếu, đặt câu hỏi làm rõ, đánh giá complexity, quản lý version và trạng thái.
- **Spec Agent:** Đọc `USER_INTENT.md` và memory để sinh đặc tả nghiệp vụ `SPEC.md`.
- **Plan Agent:** Chuyển Spec thành `PLAN.md` (Bản kế hoạch dễ hiểu cho user + Technical Execution Plan cho máy).
- **Execution Agent:** Đọc manifest đã duyệt và gọi các Tools trong allowlist. Không chạy code tùy ý.

---

## 5. Tool Layer & Validation Policy
- **Tool Registry:** Mỗi công cụ ngoài (ví dụ: database, file generator) phải có schema đầu vào/đầu ra rõ ràng và nằm trong allowlist.
- **Validation Rules:**
  - **Blocking validation:** Lỗi nghiêm trọng (sai định dạng, lỗi công thức, rỗng cột bắt buộc) -> Chặn bàn giao.
  - **Warning validation:** Lỗi không nghiêm trọng (thiếu thông tin không bắt buộc) -> Hiển thị cảnh báo.
- **Retry Policy:** Tự động retry tối đa 2 lần đối với transient errors; chuyển planner/báo lỗi nếu gặp schema error.

---

## 6. Persistent Memory & Context Management
- **User Preference Memory:** Lưu sở thích chung (ngôn ngữ, múi giờ, định dạng).
- **Workspace Memory:** Lưu quy ước ổn định của dự án (tên cột hay dùng, thư mục lưu trữ mặc định).
- **Episodic Memory:** Chỉ lưu tóm tắt task, spec version, outcome và bài học kinh nghiệm. KHÔNG lưu dữ liệu nhạy cảm của khách hàng.
- **Context Management:** Phân phối data tối giản cho từng node thông qua `ContextPack` để tiết kiệm context window và token budget.
