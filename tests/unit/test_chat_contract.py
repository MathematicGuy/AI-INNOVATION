from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


def test_chat_returns_public_envelope_without_internal_fields():
    resp = client.post("/api/v1/chat", json={"message": "hello"})
    assert resp.status_code == 200
    body = resp.json()
    assert set(body.keys()) == {"answer", "explanation", "sources", "trace_id", "status"}
    assert "analysis" not in body
    assert body["status"] == "success"
    assert isinstance(body["sources"], list)
    assert body["trace_id"]


def test_chat_error_returns_generic_envelope(monkeypatch):
    async def boom(_payload):
        raise RuntimeError("secret internal detail")

    monkeypatch.setattr("src.api.routes.agent.ainvoke", boom)
    resp = client.post("/api/v1/chat", json={"message": "hi"})
    assert resp.status_code == 500
    body = resp.json()
    assert "secret internal detail" not in resp.text
    assert body["detail"]["status"] == "error"
    assert body["detail"]["trace_id"]
