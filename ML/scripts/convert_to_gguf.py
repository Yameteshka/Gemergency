# scripts/convert_to_gguf.py
"""
Script for converting a fine-tuned Hugging Face model to GGUF format.

This script performs two main operations:
1.  Converts the saved Hugging Face model to a base F16 GGUF file.
2.  Quantizes the base GGUF file into several smaller formats (e.g., Q4_K_M).

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
MODEL_INPUT_DIR: str = "/app/model_input"
MODEL_OUTPUT_DIR: str = "/app/model_output"
LLAMA_CPP_DIR: str = "/app/llama.cpp"

# "gemma-finetuned-Q3_K_M.gguf",
# --- Quantization Settings ---
GGUF_F16_FILENAME: str = "gemma-finetuned-F16.gguf"
QUANT_VERSIONS: dict[str, str] = {
    "Q4_K_M": "gemma-finetuned-Q4_K_M.gguf",
}


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
    except FileNotFoundError:
        logging.error(f"Command not found. Ensure path '{command_list[0]}' is correct.")
        sys.exit(1)


def main() -> None:
    """Main function to run the conversion and quantization pipeline."""
    os.makedirs(MODEL_OUTPUT_DIR, exist_ok=True)

    logging.info("--- Step 1: Converting to F16 GGUF... ---")
    convert_script_path = os.path.join(LLAMA_CPP_DIR, "convert_hf_to_gguf.py")
    f16_output_path = os.path.join(MODEL_OUTPUT_DIR, GGUF_F16_FILENAME)

    if not os.path.exists(f16_output_path):
        convert_command = [
            "python3", convert_script_path, MODEL_INPUT_DIR,
            "--outfile", f16_output_path, "--outtype", "f16"
        ]
        run_command(convert_command)
        logging.info(f"--- Success! F16 model saved to {f16_output_path} ---")
    else:
        logging.info(f"--- Skipping, F16 file already exists: {f16_output_path} ---")

    quantize_binary_path = os.path.join(LLAMA_CPP_DIR, "build", "bin", "llama-quantize")

    for quant_method, quant_filename in QUANT_VERSIONS.items():
        output_path = os.path.join(MODEL_OUTPUT_DIR, quant_filename)
        if not os.path.exists(output_path):
            logging.info(f"--- Step 2: Quantizing to {quant_method}... ---")
            quantize_command = [
                quantize_binary_path, f16_output_path, output_path, quant_method
            ]
            run_command(quantize_command)
            logging.info(f"--- Success! {quant_method} model saved to {output_path} ---")
        else:
            logging.info(f"--- Skipping, {quant_method} file already exists: {output_path} ---")

    logging.info("=" * 80)
    logging.info("CONVERSION AND QUANTIZATION STAGES COMPLETED SUCCESSFULLY!")
    logging.info(f"Your GGUF files are ready in the host directory mapped to {MODEL_OUTPUT_DIR}:")
    for filename in QUANT_VERSIONS.values():
        logging.info(f" - {filename}")
    logging.info("=" * 80)


if __name__ == "__main__":
    main()