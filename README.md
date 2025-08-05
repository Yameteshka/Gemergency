# Gemergency

## Overview

We are very excited to present **Gemergency** — an iOS help assistant app based on **Google Gemma 3n** LLM. This project was built for the [Google Gemma 3n Impact Challenge](https://www.kaggle.com/competitions/google-gemma-3n-hackathon) on Kaggle.

---

## Why This Project Matters

In moments of crisis, **every second counts** — but most people freeze or forget what to do. We believe that everyone deserves **instant, trustworthy help**, no matter where they are or what device they use.

**Gemergency** transforms **Google Gemma 3n** into an **offline-first AI assistant** that guides users step-by-step through emergencies — from home accidents and natural disasters to health crises — with advice that is clear, safe, and scientifically sound.

Unlike most AI apps, our solution works **without internet access**. That means you can get lifesaving guidance anywhere:

- On a plane  
- In the wild  
- During blackouts  
- Or simply when you're overwhelmed and your mind goes blank

We know that under stress, people don’t read instructions — they need **actionable, friendly support**. Our AI doesn't just repeat generic advice: it provides **concise, situation-specific steps**.

We are building a world where anyone, anywhere, can get **calm, reliable help** — even when it feels like there’s no one around.

Whether you’re treating a deep cut, coping with a fire, or facing a natural disaster, our offline **Gemma 3n** assistant is always there for you — **no signal, no panic, just help**.

---

### Try It Out

You can try **Gemergency** by:

- Downloading [TestFlight](https://apps.apple.com/us/app/testflight/id899247664) from the App Store  
- Gaining access to the beta version of Gemergency on [TestFlight](https://testflight.apple.com/join/uAbAGUsP)


---

## Documentation
In this documentation, you will find information about the model training process, app development, and how everything works together.

To explore the project setup process, choose one of the following:

- Open the [Gemergency iOS app guide book](#) <!-- add link later -->
- Browse the [book directory](#) if you prefer not to use the guidebook <!-- add link later -->

---

## Video-presentation

[Introducing Gemergency](https://youtu.be/sfyhgup3K4U)

---

### Meet the Team: Ultra-Ochevness

- **Julia Kurnaeva** [@Yameteshka](https://github.com/Yameteshka) — ML Engineer, worked on fine-tuning Google Gemma 3n  
- **Fedya Katkov** [@charming-whaley](https://github.com/charming-whaley) — iOS Developer, built the Gemergency iOS app

---

## Roadmap

Our development followed a structured roadmap designed to gradually scale the system’s capabilities — from research and prototyping to a functional AI assistant. Each phase built upon the last, allowing us to test, optimize, and expand the app in meaningful steps.

---

### ![Status](https://img.shields.io/badge/status-done-brightgreen) Phase 1 — Model Setup & Research
- Selected **Google Gemma 3n** as the core LLM.
- Conducted a focused research sprint to assess the model's emergency response behavior.
- Validated offline inference feasibility under constrained mobile environments.
- Ran qualitative tests on representative emergency prompts.

---

### ![Status](https://img.shields.io/badge/status-done-brightgreen) Phase 2 — Deployment Format & MVP App Prototype
- Adopted **`gguf`** format with **`llama.cpp`** for mobile-optimized inference.
- Created a minimal **iOS Swift app** embedding the model with hardcoded scenarios.
- Developed the **first internal dataset** of emergency cases and AI responses for testing.
- Ensured compatibility with iOS memory and CPU limits.

---

### ![Status](https://img.shields.io/badge/status-done-brightgreen) Phase 3 — Apple Maps Integration & Functional Chat
- Integrated **Apple Maps** to support context-aware emergency flows.
- Added a **chat interface** with voice-to-text and real-time LLM feedback.
- Enabled seamless user interaction with the model through a clear and intuitive UI.

---

### ![Status](https://img.shields.io/badge/status-done-brightgreen) Phase 4 — Dataset Expansion & Multilingual Resilience
- Expanded the dataset with diverse, scenario-driven prompts.
- Added **early support for multilingual understanding** to enhance AI robustness.
- Improved clarity and relevance of step-by-step instructions across use cases.

---

## What’s Next

### ![Status](https://img.shields.io/badge/status-in--progress-yellow) Phase 5 — Migration to Google Maps
- Replacing Apple Maps with the **Google Maps SDK** to:
  - Improve address accuracy and GPS precision
  - Enable broader international coverage
  - Prepare for future features like location-based incident alerts
- Refactoring current map logic for smoother migration and easier expansion

---

### ![Status](https://img.shields.io/badge/status-planned-lightgrey) Phase 6 — Expanded Language Support
- Full implementation of **multilingual AI guidance**, including:
  - 🇩🇪 German
  - 🇪🇸 Spanish
  - 🇫🇷 French
  - 🇺🇦 Ukrainian
  - 🇸🇦 Arabic
  - 🇮🇳 Hindi
- Adjusting prompts and flows for cultural clarity and emergency terminology per language

---

### ![Status](https://img.shields.io/badge/status-planned-lightgrey) Phase 7 — Verified Emergency Dataset *(Pending Funding)*
- If awarded funding (e.g., from this Hackathon), we will:
  - Collaborate with certified **emergency professionals and medics**
  - Build a **scientifically verified dataset** for life-critical guidance
  - Ensure all steps follow **medical best practices and local legal standards**

---

### ![Status](https://img.shields.io/badge/status-planned-lightgrey) Phase 8 — Model Improvements & Advanced Compression
- Investigate:
  - **Low-bit quantization** techniques (e.g., 2–3 bit)
  - **Knowledge distillation and pruning** to reduce memory footprint
  - **Latency improvements** for older iOS devices
- Optimize the trade-off between **model size, speed, and response quality**
