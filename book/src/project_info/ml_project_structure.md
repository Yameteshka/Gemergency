<h1>📂 Project Structure</h1>

```
gemma_local_trainer/
├── Dockerfile              # Main training & inference environment
├── Dockerfile.convert      # Separate environment for GGUF conversion
├── README.md               # Project documentation (this file)
├── demo.ipynb              # Interactive demonstration notebook
├── requirements.txt
├── data/
│   └── emergency_dataset.jsonl
├── models/
│   ├── finetuned/          # Stores LoRA adapters and the final merged model
│   └── gguf/               # Stores quantized GGUF models
├── scripts/
│   ├── convert_to_gguf.py
│   └── inference_gguf.py
└── src/
    ├── __init__.py
    ├── config.py           # Centralized configuration
    ├── inference.py        # Inference script for the fine-tuned model
    ├── train_pipeline.py   # Main training and merging pipeline
    └── utils.py
```