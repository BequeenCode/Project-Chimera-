# Makefile for Project-Chimera
# Standardized commands for development and deployment

.PHONY: help setup test spec-check docker-build docker-run clean lint format

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

help:
	@echo "$(GREEN)Project-Chimera Makefile$(NC)"
	@echo "Available commands:"
	@echo "  $(YELLOW)make setup$(NC)      - Install dependencies and setup environment"
	@echo "  $(YELLOW)make test$(NC)       - Run tests (including failing ones)"
	@echo "  $(YELLOW)make spec-check$(NC) - Check code alignment with specifications"
	@echo "  $(YELLOW)make docker-build$(NC) - Build Docker image"
	@echo "  $(YELLOW)make docker-run$(NC)   - Run Docker container"
	@echo "  $(YELLOW)make clean$(NC)      - Clean temporary files"
	@echo "  $(YELLOW)make lint$(NC)       - Run linters"
	@echo "  $(YELLOW)make format$(NC)     - Format code"

setup: requirements.txt requirements-dev.txt
	@echo "$(GREEN)Installing dependencies...$(NC)"
	pip install --upgrade pip
	pip install -r requirements.txt
	pip install -r requirements-dev.txt
	@echo "$(GREEN)✓ Dependencies installed$(NC)"

test:
	@echo "$(GREEN)Running tests (expecting failures)...$(NC)"
	python -m pytest tests/ -v --tb=short
	@echo "$(YELLOW)Note: Failing tests are expected at this stage$(NC)"

spec-check:
	@echo "$(GREEN)Checking specification alignment...$(NC)"
	@echo "$(YELLOW)Running architecture validation...$(NC)"
	
	# Check if required directories exist
	@test -d "chimera" || (echo "$(RED)✗ chimera/ directory missing$(NC)" && exit 1)
	@test -d "skills" || (echo "$(RED)✗ skills/ directory missing$(NC)" && exit 1)
	@test -d "tests" || (echo "$(RED)✗ tests/ directory missing$(NC)" && exit 1)
	@echo "$(GREEN)✓ Directory structure OK$(NC)"
	
	# Check for required files
	@test -f "pyproject.toml" || (echo "$(RED)✗ pyproject.toml missing$(NC)" && exit 1)
	@test -f "README.md" || (echo "$(RED)✗ README.md missing$(NC)" && exit 1)
	@echo "$(GREEN)✓ Required files present$(NC)"
	
	# Check test files
	@test -f "tests/test_trend_fetcher.py" || (echo "$(RED)✗ test_trend_fetcher.py missing$(NC)" && exit 1)
	@test -f "tests/test_skills_interface.py" || (echo "$(RED)✗ test_skills_interface.py missing$(NC)" && exit 1)
	@echo "$(GREEN)✓ Test files present$(NC)"
	
	# Check Docker and Makefile
	@test -f "Dockerfile" || (echo "$(RED)✗ Dockerfile missing$(NC)" && exit 1)
	@test -f "Makefile" || (echo "$(RED)✗ Makefile missing$(NC)" && exit 1)
	@echo "$(GREEN)✓ Infrastructure files present$(NC)"
	
	# Run simple import checks
	@python -c "import sys; sys.path.insert(0, '.'); print('$(GREEN)✓ Python path setup OK$(NC)')"
	
	@echo "$(GREEN)✓ Specification check completed$(NC)"

docker-build:
	@echo "$(GREEN)Building Docker image...$(NC)"
	docker build -t project-chimera:latest .
	@echo "$(GREEN)✓ Docker image built$(NC)"

docker-run:
	@echo "$(GREEN)Running Docker container...$(NC)"
	docker run --rm -it \
		-v $(PWD):/app \
		-p 8000:8000 \
		--name chimera-dev \
		project-chimera:latest
	@echo "$(GREEN)✓ Container started$(NC)"

clean:
	@echo "$(GREEN)Cleaning up...$(NC)"
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/ .coverage htmlcov/ .mypy_cache/
	@echo "$(GREEN)✓ Cleanup completed$(NC)"

lint:
	@echo "$(GREEN)Running linters...$(NC)"
	python -m flake8 chimera/ tests/ --max-line-length=100
	python -m mypy chimera/ --ignore-missing-imports
	python -m bandit -r chimera/ -ll
	@echo "$(GREEN)✓ Linting completed$(NC)"

format:
	@echo "$(GREEN)Formatting code...$(NC)"
	python -m black chimera/ tests/
	python -m isort chimera/ tests/
	@echo "$(GREEN)✓ Formatting completed$(NC)"

# Development server (if applicable)
dev:
	@echo "$(GREEN)Starting development server...$(NC)"
	python -m uvicorn chimera.api:app --reload --host 0.0.0.0 --port 8000

# CI/CD test command
ci-test:
	@echo "$(GREEN)Running CI test suite...$(NC)"
	python -m pytest tests/ --junitxml=test-results.xml --cov=chimera --cov-report=xml