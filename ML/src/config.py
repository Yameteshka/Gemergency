# src/config.py
"""
Centralized configuration file for the Gemma 3n Fine-Tuning project.

This file centralizes all parameters, paths, and model settings to ensure
consistency and ease of modification.
"""
from unsloth import is_bfloat16_supported
from pathlib import Path
import torch

# --- Core Project Paths ---
# We use pathlib for OS-agnostic path handling.
# Path(__file__).resolve() gives the absolute path to this file (config.py).
# .parent gives the directory of this file (src/).
# .parent.parent gives the project root directory.
PROJECT_ROOT = Path(__file__).resolve().parent.parent

# --- Data and Model Directories ---
# All data, models, and outputs are organized into subdirectories within the project root.
DATA_DIR = PROJECT_ROOT / "data"
MODELS_DIR = PROJECT_ROOT / "models"
SRC_DIR = PROJECT_ROOT / "src"

# --- Training & Model Artifact Paths ---
# Paths for the inputs and outputs of the training pipeline.
DATASET_PATH = DATA_DIR / "emergency_dataset.jsonl"
LORA_ADAPTERS_PATH = MODELS_DIR / "finetuned" / "gemma_3n_finetuned_adapters"
MERGED_MODEL_PATH = MODELS_DIR / "finetuned" / "gemma_3n_finetuned_merged"

# --- Core Model Parameters ---
# The base model from Unsloth is chosen for its memory efficiency and speed.
BASE_MODEL_NAME = "unsloth/gemma-3n-E2B-it"
MAX_SEQ_LENGTH = 1024  # Max sequence length for the model.
# Use bfloat16 if supported for better performance on modern GPUs, else float16.
DTYPE = torch.bfloat16 if is_bfloat16_supported() else torch.float16
DEVICE_MAP = "auto" # Let Accelerate handle device placement automatically.

# --- Training Hyperparameters (SFTConfig) ---
# These parameters are grouped here for easy tuning.
TRAINING_ARGS = {
    "per_device_train_batch_size": 2,
    "gradient_accumulation_steps": 4, # Effective batch size = 2 * 4 = 8
    "warmup_steps": 5,
    "max_steps": 100,
    "learning_rate": 2e-4,
    "logging_steps": 10,
    "optim": "paged_adamw_8bit", # Memory-efficient Adam optimizer
    "seed": 3407,
    "save_steps": 50,
    "report_to": "none", # Disable reporting to services like W&B for this script
    "neftune_noise_alpha": 5, # A technique to improve fine-tuning robustness
}

# --- LoRA (PEFT) Configuration ---
# Parameters for Parameter-Efficient Fine-Tuning (PEFT) using LoRA.
LORA_CONFIG = {
    "r": 16, # The rank of the update matrices. A common value.
    "lora_alpha": 16, # LoRA scaling factor.
    "lora_dropout": 0,
    "bias": "none",
    "target_modules": [
        "q_proj", "k_proj", "v_proj", "o_proj",
        "gate_proj", "up_proj", "down_proj",
    ],
}