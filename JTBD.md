# JTBD — [Tên Dự Án / Bài Toán AI]

> [!IMPORTANT]
> **HACKATHON TEMPLATE & EXAMPLE**
> This file is a template and abstract example. Update all bracketed placeholders `[...]` with your actual hackathon project details.

## 1. Project Snapshot

**Tên dự án tạm thời:** [Project Name]  
**Nhóm:** [AI Product / AI Engineering MVP]  
**Thị trường mục tiêu:** [Mô tả thị trường và đối tượng mục tiêu]

**Bài toán nhóm đang giải quyết:**  
[Mô tả vấn đề cụ thể mà người dùng nghiệp vụ đang gặp phải. Ví dụ: Người dùng cần thực hiện công việc X nhưng thiếu kỹ năng lập trình hoặc công cụ chuyên dụng, phải làm thủ công mất nhiều thời gian.]

MVP tập trung vào một AI Agent có thể:
1. Nhận yêu cầu bằng ngôn ngữ tự nhiên.
2. Hỏi làm rõ thông tin quan trọng (tối đa 2–3 câu).
3. Ghi nhận intent và assumptions của người dùng.
4. Tạo Spec/Plan có thể review trước khi chạy.
5. Thực thi thông qua một Tool Layer có kiểm soát.
6. Tự động validate kết quả đầu ra.
7. Hiển thị Structured Activity Trace trên giao diện.

---

## 2. Market Context
[Mô tả bối cảnh thị trường hiện tại, các giải pháp thay thế đang được sử dụng và tại sao giải pháp AI Agent này mang lại giá trị vượt trội ở thời điểm hiện tại.]

---

## 3. Job Executor
- **Primary Job Executor:** [Người dùng trực tiếp sử dụng sản phẩm]
- **Secondary Job Executors:** [Người liên quan hưởng lợi từ kết quả]

---

## 4. Core JTBD
> **Khi** [bối cảnh / tình huống xảy ra],  
> **tôi muốn** [AI Agent hỗ trợ hành động / đầu ra mong muốn],  
> **để tôi có thể** [đạt được kết quả kinh doanh / nghiệp vụ mong đợi mà không cần tự xây từ đầu hoặc nhờ hỗ trợ kỹ thuật].

---

## 5. Job Stories
- **Job Story 1:** Khi yêu cầu ban đầu còn thiếu hoặc mơ hồ, tôi muốn AI chỉ hỏi những câu thực sự ảnh hưởng đến cấu trúc và logic đầu ra, để tôi không phải viết một bản đặc tả kỹ thuật dài.
- **Job Story 2:** Khi task phức tạp, tôi muốn xem Spec/Plan trước, để xác nhận AI đã hiểu đúng trước khi thực hiện.
- **Job Story 3:** Khi task đơn giản, tôi muốn AI tự thực thi ngay, để không phải duyệt những bước không cần thiết.

---

## 6. JTBD Lite Map
| Job Step | User cần làm gì | Outcome mong muốn |
|---|---|---|
| 1. Mô tả nhu cầu | Nhập prompt ngôn ngữ tự nhiên | AI nhận diện đúng intent chính |
| 2. Làm rõ | Trả lời tối đa 2–3 câu hỏi | Chỉ làm rõ các thông tin ảnh hưởng lớn |
| 3. Xác nhận cách hiểu | Xem Spec/Plan | Phát hiện sai lệch trước khi thực thi |
| 4. Tạo sản phẩm | Agent gọi Tool Layer | Sản phẩm được tạo nhất quán và có thể trace |
| 5. Kiểm tra | Hệ thống chạy validation | Phát hiện lỗi trước khi bàn giao |

---

## 7. Pain Points
[Liệt kê các điểm đau trước, trong và sau khi thực hiện công việc theo cách truyền thống.]

---

## 8. MVP Use Case
- **Prompt ví dụ:** [Nhập prompt mẫu ở đây]
- **Phạm vi đầu ra (Scope):** [Danh sách tính năng/đầu ra nằm trong MVP]
- **Default assumptions:** [Danh sách giả định mặc định áp dụng khi thiếu thông tin]
- **Ngoài phạm vi MVP:** [Các tính năng phức tạp để lại sau MVP]

---

## 9. Success Signals
[Các tín hiệu chứng minh MVP hoạt động hiệu quả, ví dụ: số câu hỏi làm rõ <= 3, tỷ lệ phê duyệt của người dùng >= 80%, v.v.]
