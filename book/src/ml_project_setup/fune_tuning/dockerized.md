<h2>The Dockerized Workflow</h2>

<p>To eliminate environment-related issues and ensure perfect reproducibility, the entire project is containerized.</p>
<ul>
    <li><b><code>gemma-trainer</code> (<code>Dockerfile</code>)</b>: This is the primary container for training and inference. It packages the Python environment, CUDA, and all necessary libraries from <code>requirements.txt</code>. By mounting local directories as volumes, we can iterate on code locally and execute it within the consistent container environment.</li>
    <li><b><code>gguf-converter</code> (<code>Dockerfile.convert</code>)</b>: The GGUF conversion process requires <b>cmake</b> and other build tools to compile <code>llama.cpp</code>. To avoid bloating our main training image, we isolate these dependencies in a separate, dedicated container. This separation of concerns is a best practice for maintaining lean and specialized environments.</li>
</ul>