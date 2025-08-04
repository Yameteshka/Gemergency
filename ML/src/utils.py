# src/utils.py
"""
Utility functions for the project.

This module contains helper functions used across different parts of the
application to promote code reuse and maintain a consistent style.
"""
import logging

# Define constants for consistent logging style
LOG_SEPARATOR_CHAR = "="
LOG_SEPARATOR_LENGTH = 70

def log_section_header(title: str) -> None:
    """
    Logs a formatted section header to the console.

    This ensures all major sections in the logs have a consistent,
    professional look.

    Args:
        title (str): The title of the section to be logged.
    """
    separator = LOG_SEPARATOR_CHAR * LOG_SEPARATOR_LENGTH
    logging.info(separator)
    logging.info(f"--- {title.upper()} ---")
    logging.info(separator)

def log_final_summary(messages: list[str]) -> None:
    """
    Logs a formatted final summary box.

    Args:
        messages (list[str]): A list of strings to be displayed inside the box.
    """
    separator = LOG_SEPARATOR_CHAR * LOG_SEPARATOR_LENGTH
    logging.info("\n" + separator)
    for message in messages:
        logging.info(f"{message}")
    logging.info(separator)