FROM python:3.11-slim

# Node.js + npm (node runtime bot er jonno) ar build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
        nodejs npm git build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Railway volume ta /data e mount korbo; data.json ar servers/ ekhane thakbe
ENV DATA_DIR=/data
RUN mkdir -p /data

CMD ["sh", "-c", "gunicorn app:app --bind 0.0.0.0:${PORT:-5000} --workers 1 --threads 4 --timeout 120"]
