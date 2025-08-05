<h2>Base Model: <code>unsloth/gemma-3n-E2B-it</code></h2>
<p>We selected <b>Gemma</b>, a family of lightweight, state-of-the-art open models from Google, as our foundation. Specifically, we chose the <code>unsloth/gemma-3n-E2B-it</code> variant.</p>
<ul>
    <li><b>Architecture</b>: Gemma models are based on the same decoder-only Transformer architecture as the Gemini models. The "3n" variant is a <b>multimodal</b> model, equipped with a Vision Language Encoder, making it capable of processing both text and image inputs. While this project focuses on text-to-text fine-tuning, the multimodal foundation offers a clear path for future expansion (e.g., analyzing photos of injuries).</li>
    <li><b>Training and Capabilities</b>: The <code>-it</code> suffix signifies that the model is <b>Instruction Tuned</b>. Following its extensive pre-training on a diverse corpus of up to 6 trillion tokens of text and code, it underwent supervised fine-tuning (SFT) and reinforcement learning from human feedback (RLHF) to enhance its ability to follow instructions and engage in helpful dialogue.</li>
    <li><b>Known Limitations</b>: As with all LLMs, Gemma is not immune to generating factually incorrect or biased information. Google's official documentation notes that while safety filters are in place, the model may not always capture nuances and can sometimes produce responses that are plausible but incorrect. This limitation was a primary motivator for our targeted fine-tuning, aiming to instill domain-specific accuracy for emergency scenarios.</li>
</ul>
<p><b>References</b></p>
<ul>
    <li><a href="https://deepmind.google/models/gemma/">Google DeepMind's Gemma</a></li>
    <li><a href="https://ai.google.dev/gemma/docs">Google's documentation</a></li>
    <li><a href="https://docs.unsloth.ai/basics/gemma-3n-how-to-run-and-fine-tune">Unsloth docs</a></li>
</ul>