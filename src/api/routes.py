import logging
import uuid

from fastapi import APIRouter, HTTPException

from src.agents.graph import agent
from src.models.schemas import ChatRequest, ChatResponse

logger = logging.getLogger(__name__)
router = APIRouter()


@router.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest) -> ChatResponse:
    """Chat với AI agent."""
    trace_id = uuid.uuid4().hex
    try:
        result = await agent.ainvoke({"query": request.message})
        return ChatResponse(
            answer=result.get("response", ""),
            explanation=result.get("explanation", ""),
            sources=result.get("sources", []),
            trace_id=trace_id,
            status="success",
        )
    except Exception:
        logger.exception("chat failed", extra={"trace_id": trace_id})
        raise HTTPException(
            status_code=500,
            detail={
                "status": "error",
                "trace_id": trace_id,
                "message": "Internal error. Reference the trace_id when reporting.",
            },
        )


@router.get("/status")
async def agent_status():
    """Kiểm tra trạng thái agent."""
    return {"status": "ready", "agent": "LangGraph Agent v1.0"}
