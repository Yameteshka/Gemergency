# Dockerfile for Gemma 3n Development Environment

# This Dockerfile prepares a consistent environment with all necessary
# system and Python dependencies for GPU-accelerated training.
# The source code is NOT copied into the image; it is mounted at runtime.

# ==============================================================================
# STAGE 1: BASE IMAGE & SYSTEM DEPENDENCIES
# ==============================================================================
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.11 \
        python3.11-dev \
        python3.11-venv \
        git \
        build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ==============================================================================
# STAGE 2: PYTHON VIRTUAL ENVIRONMENT
# ==============================================================================
RUN python3.11 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# ==============================================================================
# STAGE 3: PYTHON DEPENDENCIES
# ==============================================================================
WORKDIR /app

RUN python -m pip install --no-cache-dir --upgrade pip

# Copy the requirements file into the image.
COPY requirements.txt .

# --- CRITICAL TWO-STEP INSTALLATION ---
# STEP 3.1: Install Unsloth first.
# Unsloth pulls in specific, compatible versions of torch, xformers, etc.
# This must be done in a separate step.
RUN pip install --no-cache-dir "unsloth[cu121-ampere-torch23]"

# STEP 3.2: Install the remaining dependencies from requirements.txt.
# This ensures our specific versions (like transformers<4.54) are respected
# after the base Unsloth installation is complete.
RUN pip install --no-cache-dir -r requirements.txt

# ==============================================================================
# STAGE 4: DEFAULT COMMAND
# ==============================================================================
# Provide a bash shell by default. The actual command for running scripts
# will be provided during the 'docker run' command.
CMD ["bash"]