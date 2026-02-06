# Dockerfile for Project-Chimera AI Swarm
# Multi-stage build for production and development

# Stage 1: Base image with Python and system dependencies
FROM python:3.11-slim as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app \
    PIP_NO_CACHE_DIR=1

# Stage 2: Development environment
FROM base as development

# Install development dependencies
COPY requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

# Copy project files
COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 chimera && \
    chown -R chimera:chimera /app
USER chimera

# Expose port for API (if needed)
EXPOSE 8000

# Default command for development
CMD ["python", "-m", "pytest", "tests/", "-v"]

# Stage 3: Production environment
FROM base as production

# Copy only production requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY chimera/ chimera/
COPY pyproject.toml .
COPY README.md .

# Create non-root user
RUN useradd -m -u 1000 chimera && \
    chown -R chimera:chimera /app
USER chimera

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD python -c "import sys; sys.exit(0)"

# Production command (override in docker-compose or k8s)
CMD ["python", "-m", "chimera.main"]