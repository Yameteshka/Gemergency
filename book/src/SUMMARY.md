# Summary

[Overview](project_info/overview.md)
[ML project structure](project_info/ml_project_structure.md)

# Gemma 3n setup

- [Original Model & Tooling Overview](ml_project_setup/model/model.md)
    - [Base model](ml_project_setup/model/base_model.md)
    - [Justification for Tooling Choices](ml_project_setup/model/justification.md)
- [Model Fine-Tuning Process](ml_project_setup/fune_tuning/fine_tuning.md)
  - [The Dockerized Workflow](ml_project_setup/fune_tuning/dockerized.md)
  - [Data Curation and Preprocessing](ml_project_setup/fune_tuning/data_curation.md)
  - [Fine-Tuning Strategy: QLoRA](ml_project_setup/fune_tuning/strategy.md)
  - [Hyperparameter Rationale](ml_project_setup/fune_tuning/hyperparameter.md)
  - [Model Merging](ml_project_setup/fune_tuning/merging.md)
- [Results Comparison & Final Model Selection](ml_project_setup/results/results.md)
  - [Qualitative Improvement](ml_project_setup/results/qualitative.md)
  - [Quantitative Safety Evaluation (GGUF Models)](ml_project_setup/results/safety.md)
  - [Conclusion and Final Model Choice](ml_project_setup/results/conclusion.md)
- [Setup & Usage](ml_project_setup/usage/usage.md)
- [Interactive Demonstration Notebook](ml_project_setup/notebook_demonstration/notebook_demo.md)

# iOS setup

- [Inference setup](ios_project_setup/inference.md)
- [App setup](ios_project_setup/app_setup.md)
- [Publishing app](ios_project_setup/publishing.md)