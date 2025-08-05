<h1>🚀 Setup & Usage</h1>
<p>This project uses a Docker-based development workflow. The <code>Dockerfile</code> creates a consistent environment with all dependencies, and the source code is mounted into the container at runtime.</p>
<h2>Prerequisites</h2>
<ul>
    <li><a href="https://www.docker.com/get-started">Docker</a> installed and running</li>
    <li><a href="https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html">Docker</a> installed for GPU access within Docker</li>
</ul>

<h3>Step 1: Build the Docker Image</h3>
<p>Build the main Docker image, which contains the Python environment and all dependencies.</p>

```bash
docker build -t gemma-trainer .
```

<h3>Step 2: Run the Training Pipeline</h3>
<p>This command executes the full training and merging pipeline. The final merged model will be saved to your local <code>./models/finetuned</code> directory.</p>

```bash
docker run --gpus all -it --rm -e TORCH_COMPILE_DISABLE=1 -v "$(pwd)/src:/app/src" -v "$(pwd)/scripts:/app/scripts" -v "$(pwd)/data:/app/data:ro" -v "$(pwd)/models:/app/models" gemma-trainer python -m src.train_pipeline
```
<p><b>Note: <code>TORCH_COMPILE_DISABLE=1</code> is a required flag to prevent conflicts between PyTorch 2's compiler and Unsloth's deep optimizations.</b></p>

<h3>Step 3: Run Inference with the Fine-Tuned Model</h3>
<p>After training, use this command to get a response from your fine-tuned model.</p>

```bash
docker run --gpus all -it --rm -e TORCH_COMPILE_DISABLE=1 -v "$(pwd)/src:/app/src" -v "$(pwd)/models:/app/models:ro" gemma-trainer python -m src.inference --prompt "What is the first aid for a burn?"
```

<h3>Step 4: Convert Model to GGUF (Optional)</h3>
<p>To create the highly efficient GGUF models for broad deployment, use the separate converter environment.</p>

1.  <b>Build the Converter Image</b>
    ```bash
    docker build -t gguf-converter -f Dockerfile.convert .
    ```
2.  <b>Run the Conversion Script</b>
    <p>This command mounts your fine-tuned model as input and saves the resulting <code>.gguf</code> files to your local <code>./models/gguf</code> directory.</p>

    ```bash
    docker run -it --rm -v "$(pwd)/models/finetuned/gemma_3n_finetuned_merged:/app/model_input:ro" -v "$(pwd)/models/gguf:/app/model_output" -v "$(pwd)/scripts/convert_to_gguf.py:/app/convert_to_gguf.py" gguf-converter python /app/convert_to_gguf.py
    ```

<h3>Step 5: Test GGUF Models (Optional)</h3>
<p>Run the comparative inference script within the <code>gguf-converter</code> container to test your newly created GGUF models.</p>

```bash
docker run -it --rm -v "$(pwd)/models/gguf:/app/models:ro" -v "$(pwd)/scripts/inference_gguf.py:/app/inference_gguf.py" gguf-converter python /app/inference_gguf.py
```