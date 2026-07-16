# [Tên Dự Án]

> Tóm tắt 1 câu: [Vấn đề] → [Giải pháp AI] cho [Target User]

## Vấn đề (Problem)

Mô tả pain point cụ thể với data/số liệu:
- Ai đang gặp vấn đề?
- Vấn đề tốn bao nhiêu thời gian/tiền?
- Tại sao các giải pháp hiện tại chưa đủ?

## Giải pháp (Solution)

Sản phẩm giải quyết vấn đề như thế nào bằng AI:
- Feature 1: [mô tả]
- Feature 2: [mô tả]
- Feature 3: [mô tả]

## Target User

- Primary: [mô tả user chính]
- Secondary: [mô tả user phụ]

## Tech Stack

| Layer | Technology |
|-------|-----------|
| AI Agent | LangGraph + [LLM] |
| Backend | FastAPI + Python 3.11+ |
| Frontend | React/Next.js + TypeScript |
| Database | PostgreSQL / SQLite |
| DevOps | Docker + GitHub Actions |

## Quick Start

```bash
# 1. Clone repo
git clone https://github.com/a20-ai-thuc-chien/A20-App-XXX.git
cd A20-App-XXX

# 2. Setup environment
cp .env.example .env
# Edit .env with your API keys

# 3. Install dependencies
pip install -r requirements.txt

# 4. Run backend development server
uvicorn src.main:app --reload

# 5. Run frontend development server
cd frontend
npm install
npm run dev
```

## Project Structure

```text
├── frontend/            # Mã nguồn Frontend (React/TS + Vite)
├── src/
│   ├── agents/          # LangGraph agent definitions
│   │   ├── graph.py     # Main graph (nodes + edges)
│   │   ├── state.py     # State schema
│   │   ├── nodes/       # Individual nodes
│   │   └── tools/       # Agent tools
│   ├── api/             # FastAPI routes
│   ├── models/          # Pydantic schemas
│   ├── services/        # Business logic
│   ├── config.py        # Settings
│   └── main.py          # App entry point
├── tests/               # Test suite
├── eval/                # Evaluation results
├── presentation/        # Demo materials
├── Dockerfile           # Multi-stage build
├── docker-compose.yml   # Full stack
├── .github/workflows/   # CI/CD pipelines
│   └── codebase-mcp.yml # Tự động index codebase-memory-mcp khi push/PR
├── AGENTS.md            # Hướng dẫn Coding Agent cục bộ của dự án
└── docs/                # Tài liệu dự án & Khung quy trình Harness
    ├── HARNESS.md       # Luồng cộng tác human-agent
    ├── FEATURE_INTAKE.md # Đánh giá rủi ro tính năng (tiny/normal/high-risk)
    ├── ARCHITECTURE.md  # Ranh giới kiến trúc và kiểm soát tích hợp
    ├── TEST_MATRIX.md   # Bảng đối chiếu kiểm thử thực tế và yêu cầu
    ├── HARNESS_BACKLOG.md # Danh sách thiếu sót quy trình cần bổ sung
    ├── product/         # Tài liệu đặc tả sản phẩm (Harness Product Source)
    ├── stories/         # Danh sách story packet chi tiết (Harness Product Source)
    ├── decisions/       # Quyết định kiến trúc quan trọng - ADR (Harness Product Source)
    └── templates/       # Các mẫu tài liệu đặc tả và story
```

## Harness Product Sources

Sử dụng hệ thống tài liệu Harness để hướng dẫn các AI Coding Agent (ví dụ: Claude Code, Cursor) phát triển tính năng một cách an toàn và có kiểm chứng:

- **`docs/product/`**: Các tài liệu thiết kế nghiệp vụ (product contracts), mô tả hành vi hệ thống mong muốn được trích xuất từ file đặc tả gốc.
- **`docs/stories/`**: Story packets ghi nhận chi tiết yêu cầu của từng task, tiêu chí nghiệm thu (acceptance criteria) và mã định danh verification receipt.
- **`docs/TEST_MATRIX.md`**: Ma trận kiểm thử liên kết trực tiếp hành vi nghiệp vụ với các câu lệnh kiểm thử thực tế (unit/integration/E2E tests).
- **`docs/decisions/`**: Nhật ký quyết định kiến trúc (Architecture Decision Records - ADR) để lưu lại các quyết định thiết kế quan trọng và lý do lựa chọn giải pháp.


## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check |
| POST | /api/v1/chat | Chat with agent |
| POST | /api/v1/analyze | Analyze input |

## Deliverables Checklist

- [x] Source Code (GitHub)
- [x] README.md
- [x] Architecture Diagram (`docs/architecture_diagram.md`)
- [x] AI Logs (auto-collected)
- [ ] Live URL / Deploy
- [ ] Video Demo
- [ ] Pitch Deck (`presentation/`)
- [ ] Evaluation Evidence (`eval/results/`)

## Team

| Member | Role | Student ID |
|--------|------|-----------|
| [Name] | [Role] | [ID] |
| [Name] | [Role] | [ID] |
| [Name] | [Role] | [ID] |

## License

MIT
