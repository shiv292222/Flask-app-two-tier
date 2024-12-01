# ------------------- Stage 1: Build Stage ------------------------------
# Use Python 3.9 base image to build the application dependencies
FROM python:3.9 AS builder

# Set the working directory in the container
WORKDIR /app

# Install build dependencies required for compiling Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc default-libmysqlclient-dev pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies using the requirements file
RUN pip install --no-cache-dir -r requirements.txt

# ------------------- Stage 2: Final Stage ------------------------------
# Use a lighter base image for the runtime to reduce the image size
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install only the runtime dependencies (lighter than build dependencies)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libmariadb3 && \
    rm -rf /var/lib/apt/lists/*

# Copy dependencies and application code from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY . .

# Specify the command to run the Python application
CMD ["python", "app.py"]

