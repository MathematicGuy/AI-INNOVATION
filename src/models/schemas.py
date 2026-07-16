from pydantic import BaseModel, Field


class ChatRequest(BaseModel):
    message: str = Field(..., min_length=1, max_length=5000, description="Tin nhắn từ user")


class ChatResponse(BaseModel):
    answer: str = Field(..., description="The user-facing answer")
    explanation: str = Field(default="", description="User-facing rationale (no internal diagnostics)")
    sources: list[str] = Field(default_factory=list, description="Supporting sources, if any")
    trace_id: str = Field(..., description="Correlates this response with server logs/traces")
    status: str = Field(default="success", description="success | error")
