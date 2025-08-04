# scripts/inference_gguf.py
"""
Script for testing and comparing different GGUF quantized models.

This script dynamically installs 'llama-cpp-python', then iterates through
a list of specified GGUF models, runs inference on each with a common
prompt, and prints the results for comparison.

It is designed to be run inside the 'gguf-converter' Docker container.
"""
import os
import subprocess
import sys
import logging

# --- Setup Professional Logging ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

# --- Configuration (Paths inside the Docker container) ---
MODEL_DIR: str = "/app/models"

# "gemma-finetuned-Q3_K_M.gguf",
# --- Models to Test ---
MODELS_TO_TEST: list[str] = [
    "gemma-finetuned-Q4_K_M.gguf",
]


def run_command(command_list: list[str]) -> None:
    """Executes a shell command and streams its output to the logger."""
    command_str = ' '.join(command_list)
    logging.info(f"Executing command: {command_str}")
    try:
        process = subprocess.Popen(
            command_list,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            encoding='utf-8'
        )
        for line in iter(process.stdout.readline, ''):
            logging.info(line.strip())
        process.wait()
        if process.returncode != 0:
            raise subprocess.CalledProcessError(process.returncode, command_list)
    except subprocess.CalledProcessError as e:
        logging.error(f"Command '{' '.join(e.cmd)}' failed with exit code {e.returncode}")
        sys.exit(e.returncode)


def main() -> None:
    """Main function to run the GGUF model comparison."""
    logging.info("--- Starting GGUF Model Inference Comparison ---")

    logging.info("[Step 1] Installing llama-cpp-python and torch...")
    pip_install_command = ["python3", "-m", "pip", "install", "--no-cache-dir", "llama-cpp-python", "torch"]
    run_command(pip_install_command)

    from llama_cpp import Llama
    import torch
    import gc

    logging.info("[Step 2] Running comparative inference...")
    question = "I cut my finger, and the bleeding won't stop. What should I do?"
    messages = [{"role": "user", "content": question}]
    logging.info(f"> Common question for all models: {question}")

    for model_filename in MODELS_TO_TEST:
        logging.info("=" * 25 + f" TESTING MODEL: {model_filename} " + "=" * 25)
        gguf_model_path = os.path.join(MODEL_DIR, model_filename)

        if not os.path.exists(gguf_model_path):
            logging.warning(f"Model file not found, skipping: {gguf_model_path}")
            continue

        try:
            logging.info(f"Loading model from {gguf_model_path}...")
            llm = Llama(model_path=gguf_model_path, n_ctx=2048, n_gpu_layers=-1, verbose=False)

            logging.info("Generating response...")
            response = llm.create_chat_completion(messages)
            answer = response['choices'][0]['message']['content']

            # Use print() for the final answer, just like in src/inference.py
            print(f"\n< Response ({model_filename}):\n{answer}")

        except Exception as e:
            logging.error(f"Error while testing model {model_filename}: {e}")
        finally:
            if 'llm' in locals():
                del llm
            gc.collect()
            if torch.cuda.is_available():
                torch.cuda.empty_cache()

    logging.info("=" * 80)
    logging.info("COMPARATIVE INFERENCE TEST FINISHED.")
    logging.info("=" * 80)


if __name__ == "__main__":
    main()