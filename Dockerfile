FROM python:3.10-slim

WORKDIR /app

# Install system dependencies (optional but recommended)
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install Python dependencies including Prometheus exporter
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# App version (Jenkins will overwrite)
ENV APP_VERSION="v1.0.0"

CMD ["python", "app.py"]

