<h2>Hyperparameter Rationale</h2>
<p>Our chosen hyperparameters in <code>src/config.py</code> are based on established best practices for LoRA fine-tuning:</p>
<ul>
    <li><b><code>learning_rate: 2e-4</code></b>: A slightly higher learning rate is often effective for LoRA as fewer weights are being updated.</li>
    <li><b><code>r: 16</code>, <code>lora_alpha: 16</code></b>: <code>r</code> defines the rank (complexity) of the adapter matrices. <code>r=16</code> offers a good balance between expressivity and parameter efficiency. Setting <code>lora_alpha</code> equal to <code>r</code> is a common heuristic for scaling.</li>
    <li><b><code>neftune_noise_alpha: 5</code></b>: We enable NEFTune, a technique that adds noise to embedding vectors during training. This acts as a regularizer, preventing overfitting and improving the robustness of the final model.</li>
</ul>