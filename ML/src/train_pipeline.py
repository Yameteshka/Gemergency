# src/train_pipeline.py
"""
Main training pipeline for fine-tuning and merging the Gemma 3n model.

This script performs two main stages:
1.  Fine-tuning the base model using QLoRA for memory efficiency. This stage
    only saves the trained adapter weights.
2.  Merging the trained LoRA adapters with the full-precision base model
    to create a final, standalone fine-tuned model.

The script is designed to be run once to produce the final model artifact.
"""
from unsloth import FastModel, is_bfloat16_supported
import gc
import logging
import torch
from datasets import load_dataset
from peft import PeftModel
from transformers import AutoTokenizer, AutoModelForCausalLM
from trl import SFTTrainer, SFTConfig

# Import the centralized configuration and utility functions
from src import config
from src.utils import log_section_header, log_final_summary

# --- Setup Professional Logging ---
# Using the logging module is preferred over print() for better control and formatting.
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)


def run_qlora_finetuning() -> None:
    """
    Stage 1: Fine-tune the model using QLoRA.

    This function loads the base model in 4-bit precision, applies LoRA adapters,
    and runs the training process using the SFTTrainer. It saves only the
    adapter weights, not the full model.
    """
    log_section_header("STAGE 1: QLORA FINE-TUNING")

    # Ensure the output directory for adapters exists
    config.LORA_ADAPTERS_PATH.mkdir(parents=True, exist_ok=True)

    logging.info(f"Loading dataset from: {config.DATASET_PATH}")
    dataset = load_dataset("json", data_files=str(config.DATASET_PATH), split="train")

    logging.info(f"Loading 4-bit base model for training: {config.BASE_MODEL_NAME}")
    model, tokenizer = FastModel.from_pretrained(
        model_name=config.BASE_MODEL_NAME,
        max_seq_length=config.MAX_SEQ_LENGTH,
        dtype=config.DTYPE,
        load_in_4bit=True,
    )

    logging.info("Applying PEFT (LoRA) configuration to the model.")
    model = FastModel.get_peft_model(
        model,
        **config.LORA_CONFIG,
        random_state=config.TRAINING_ARGS.get("seed", 3407)
    )

    def format_chat_template(sample: dict) -> dict:
        """Applies the chat template to the dataset samples."""
        messages = [
            {"role": "user", "content": sample["instruction"]},
            {"role": "assistant", "content": sample["output"]},
        ]
        return {"text": tokenizer.apply_chat_template(
            messages, tokenize=False, add_generation_prompt=False
        )}

    logging.info("Formatting dataset with chat template.")
    formatted_dataset = dataset.map(format_chat_template, num_proc=4)

    trainer = SFTTrainer(
        model=model,
        tokenizer=tokenizer,
        train_dataset=formatted_dataset,
        dataset_text_field="text",
        packing=True,
        max_seq_length=config.MAX_SEQ_LENGTH,
        args=SFTConfig(
            output_dir=str(config.LORA_ADAPTERS_PATH),
            bf16=is_bfloat16_supported(),
            fp16=not is_bfloat16_supported(),
            **config.TRAINING_ARGS
        ),
    )

    logging.info("Starting model training...")
    trainer.train()
    logging.info("Training complete.")

    logging.info(f"Saving LoRA adapters to: {config.LORA_ADAPTERS_PATH}")
    trainer.model.save_pretrained(str(config.LORA_ADAPTERS_PATH))
    tokenizer.save_pretrained(str(config.LORA_ADAPTERS_PATH))
    logging.info(f"Successfully saved LoRA adapters.")


def run_model_merge() -> None:
    """
    Stage 2: Merge LoRA adapters with the base model.

    This function loads the base model in its full precision (bfloat16/float16)
    and merges the trained adapter weights into it. The result is a new,
    standalone model that is saved to disk.
    """
    log_section_header("STAGE 2: MODEL MERGE")

    config.MERGED_MODEL_PATH.mkdir(parents=True, exist_ok=True)

    logging.info(f"Loading full-precision base model for merging: {config.BASE_MODEL_NAME}")
    model, tokenizer = FastModel.from_pretrained(
        model_name=config.BASE_MODEL_NAME,
        max_seq_length=config.MAX_SEQ_LENGTH,
        dtype=config.DTYPE,
        load_in_4bit=False,  # Critical: Load in full precision for merging
    )

    logging.info(f"Loading and attaching LoRA adapters from: {config.LORA_ADAPTERS_PATH}")
    model = PeftModel.from_pretrained(model, str(config.LORA_ADAPTERS_PATH))

    logging.info("Merging adapter weights into the base model...")
    model = model.merge_and_unload()

    logging.info(f"Saving the final merged model to: {config.MERGED_MODEL_PATH}")
    model.save_pretrained(str(config.MERGED_MODEL_PATH))
    tokenizer.save_pretrained(str(config.MERGED_MODEL_PATH))
    logging.info(f"Successfully saved merged model.")


def main():
    """Main function to orchestrate the training and merging pipeline."""
    run_qlora_finetuning()

    logging.info("Clearing GPU memory before merging...")
    gc.collect()
    torch.cuda.empty_cache()
    logging.info("Memory cleared.")

    run_model_merge()

    summary_messages = [
        "TRAINING AND MERGING PIPELINE COMPLETED SUCCESSFULLY",
        f"Final model is available at: {config.MERGED_MODEL_PATH}"
    ]
    log_final_summary(summary_messages)


if __name__ == "__main__":
    # This guard ensures the main function is called only when the script
    # is executed directly, not when imported as a module.
    main()