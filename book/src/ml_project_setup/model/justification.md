<h2>Justification for Tooling Choices</h2>

<ul>
    <li><b>Unsloth</b>: To overcome the significant computational costs of fine-tuning, we leveraged <b>Unsloth</b>. Unsloth provides highly optimized kernels that enable up to 2x faster training and reduce memory usage by 60% without sacrificing performance. This is achieved through manual autograd functions, re-engineered RoPE embeddings, and other deep optimizations. Its seamless integration (<code>FastModel</code>) allowed us to implement advanced techniques like QLoRA with minimal boilerplate code, making the entire process more efficient and accessible.</li>
    <ul>
        <li><b>Reference</b>: <a href="https://github.com/unslothai/unsloth">Unsloth GitHub Repository</a></li>
    </ul><br>
    <li><b>GGUF and <code>llama.cpp</code></b>: Our end goal is a model that is not only accurate but also deployable in resource-constrained environments. We chose the <b>GGUF (GPT-Generated Unified Format)</b> for this purpose. GGUF is a file format designed by the <code>llama.cpp</code> community for packaging and running LLMs efficiently. It quantizes model weights (reducing precision from 16-bit to as low as 2-bit), drastically shrinking file size and enabling fast inference on CPUs or consumer-grade GPUs. This makes our emergency assistant potentially deployable on edge devices or personal computers, increasing its real-world impact.</li>
    <ul>
        <li><b>Reference</b>: <a href="https://github.com/ggerganov/llama.cpp">llama.cpp GitHub Repository</a></li>
    </ul>
</ul>