format:
	ruff format src tests

format-check:
	ruff format --check src tests

check-backend:
	ruff check src tests
	ruff format --check src tests
	mypy src
	pytest -q

check-frontend:
	cd frontend && npm ci && npm run lint && npm run build

check: check-backend check-frontend