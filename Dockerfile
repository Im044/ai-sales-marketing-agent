# AI Sales & Marketing Agent - Docker Container
# Production-ready Docker image for Sales/Marketing Agent

FROM python:3.11-slim

LABEL maintainer="MOHD MUFFASIL <mdmuffasil893@gmail.com>"
LABEL description="AI Sales and Marketing Agent - Lead generation and campaign optimization"

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd -m -u 1000 aiagent && chown -R aiagent:aiagent /app
USER aiagent

# Expose port
EXPOSE 8005

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8005/health || exit 1

# Run the application
CMD ["python", "-m", "sales_marketing_agent"]
