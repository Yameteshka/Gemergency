# src/inference.py
"""
Inference script to run the fine-tuned Gemma 3n model.

This script loads the final, merged model and provides a command-line interface
to generate responses for a given prompt. It distinguishes between logging
metadata (to stderr) and printing the final result (to stdout).

Usage:
    python -m src.inference --prompt "What to do if an appliance catches fire?"
"""
import argparse
import logging
import sys
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM

# Import the centralized configuration and utility constants
from src import config
from src.utils import LOG_SEPARATOR_CHAR, LOG_SEPARATOR_LENGTH

# --- Setup Professional Logging ---
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


def setup_arg_parser() -> argparse.ArgumentParser:
    """
    Sets up the command-line argument parser.

    Using argparse makes the script a reusable and configurable tool, which is
    a standard practice for professional command-line applications.
    """
    parser = argparse.ArgumentParser(description="Run inference with the fine-tuned Gemma model.")
    parser.add_argument(
        "--prompt",
        type=str,
        required=True,
        help="The user prompt to send to the model."
    )
    parser.add_argument(
        "--max_new_tokens",
        type=int,
        default=256,
        help="The maximum number of new tokens to generate."
    )
    return parser


def generate_response(
    prompt: str,
    model: AutoModelForCausalLM,
    tokenizer: AutoTokenizer,
    max_new_tokens: int
) -> str:
    """
    Generates a response from the model for a given prompt.

    Args:
        prompt (str): The input text from the user.
        model (AutoModelForCausalLM): The loaded language model.
        tokenizer (AutoTokenizer): The loaded tokenizer.
        max_new_tokens (int): Max tokens for the generated response.

    Returns:
        str: The generated text from the model.
    """
    system_prompt = (
        "You are a helpful assistant who provides concise and accurate answers, "
        "especially in emergency situations."
    )
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": prompt},
    ]

    input_ids = tokenizer.apply_chat_template(
        messages,
        tokenize=True,
        add_generation_prompt=True,
        return_tensors="pt"
    ).to(model.device)

    outputs = model.generate(
        input_ids,
        max_new_tokens=max_new_tokens,
        use_cache=True,
        do_sample=True,
        temperature=0.7,
        top_p=0.9
    )

    response = tokenizer.decode(outputs[0][input_ids.shape[1]:], skip_special_tokens=True)
    return response.strip()


def main():
    """
    Main function to load the model and run inference.
    """
    parser = setup_arg_parser()
    args = parser.parse_args()

    logging.info(f"Loading the fine-tuned model from: {config.MERGED_MODEL_PATH}")

    try:
        model = AutoModelForCausalLM.from_pretrained(
            str(config.MERGED_MODEL_PATH),
            torch_dtype=config.DTYPE,
            device_map=config.DEVICE_MAP,
        )
        tokenizer = AutoTokenizer.from_pretrained(str(config.MERGED_MODEL_PATH))
    except OSError:
        logging.error(f"Model not found at {config.MERGED_MODEL_PATH}.")
        logging.error("Please run the training pipeline first using: python -m src.train_pipeline")
        sys.exit(1)

    logging.info("Model loaded successfully. Generating response...")
    separator = LOG_SEPARATOR_CHAR * LOG_SEPARATOR_LENGTH
    logging.info(separator)
    logging.info(f"> User Prompt: {args.prompt}")

    response = generate_response(args.prompt, model, tokenizer, args.max_new_tokens)

    # Print the final, clean result to standard output.
    # This allows for easy redirection, e.g., `... > result.txt`
    print("\n< Model Response:")
    print(response)

    # Log the final metadata.
    logging.info(separator)
    logging.info("Inference complete.")


if __name__ == "__main__":
    main()