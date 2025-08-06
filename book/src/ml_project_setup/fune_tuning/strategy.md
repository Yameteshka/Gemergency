<h2>Fine-Tuning Strategy: QLoRA</h2>
<p>Full fine-tuning of a 2-billion-parameter model would require immense VRAM. We adopted <b>QLoRA (Quantized Low-Rank Adaptation)</b>, an extremely memory-efficient technique.</p>
<ol>
    <li><b>4-bit Quantization</b>: The base model is loaded with its weights quantized to 4-bit precision (<code>load_in_4bit=True</code>). This reduces the memory footprint of the static, non-trainable part of the model by a factor of 4.</li>
    <li><b>Low-Rank Adapters (LoRA)</b>: Instead of training the entire model, we only train small, "low-rank" matrices that are injected into the attention and feed-forward layers (<code>target_modules</code> in <code>config.py</code>)</li>
    <li><b>Paged Optimizers</b>: We use the <code>paged_adamw_8bit</code> optimizer, which pages optimizer states to CPU RAM when GPU VRAM is exhausted, allowing us to train with larger batch sizes than would otherwise be possible.</li>
</ol>
<p>This approach, streamlined by Unsloth's <code>FastModel</code> class, allows for fine-tuning on a single consumer-grade GPU.</p>
<p><b>Reference</b></p>
<ul><li><a href="https://arxiv.org/abs/2305.14314">Dettmers, et al. (2023). "QLoRA: Efficient Finetuning of Quantized LLMs"</a></li></ul>
