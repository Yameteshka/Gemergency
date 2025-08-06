# Inference setup

## Integration choice

<p>In the beginning, when it comes to building an iOS app with LLM, the developer needs to choose the way it will be integrated in the app. In our case, there were standard ways of using that on-device:</p>

<ul>
    <li><a href="https://pypi.org/project/coremltools/">coremltools</a> from pip</li>
    <li><a href="https://github.com/ggml-org/llama.cpp">llama.cpp inference</a> with .gguf file extension</li>
    <li><a href="https://ai.google.dev/edge/mediapipe/solutions/guide">Google's MediaPipe</a></li>
    <li>Use of <a href="https://onnx.ai/">ONNX</a></li>
</ul>

<p>After some time of working with all these methods, we came across on pros/cons of each of those ways:</p>

<table>
  <tr>
    <th></th>
    <th>coremltools</th>
    <th>llama.cpp</th>
    <th>MediaPipe</th>
    <th>ONNX</th>
  </tr>
  <tr>
    <td>Pros</td>
    <td>Easily integrated via Apple's CoreML</td>
    <td>A developer can gain access to lower-level settings</td>
    <td>Standard way of integrating Google's LLMs</td>
    <td>Use with coremltools by running just one command</td>
  </tr>
  <tr>
    <td>Cons</td>
    <td>Not supported for now [08/03/2025]</td>
    <td>Too hard war for noobs</td>
    <td>Google Gemma 3n is not supported for now [08/03/2025]</td>
    <td>Need for high-performed Mac 16+ of RAM and Apple Silicon Pro+ processors</td>
  </tr>
</table>

<p>Unfortunately, we couldn't use <i>coremltools</i> or <i>ONNX</i>, which are considered as the best tools for using LLMs on iOS, so we narrowed such tools down to <i>llama.cpp</i> and <i>MediaPipe</i>. And, as it often happens, <i>MediaPipe</i> became not appropriate for us because we realized that there is no way to convert Google Gemma 3n into .task file extension. Hence, the only thing we could try is <i>llama.cpp</i></p>

<p>We are going through each LLM integration step in the Gemergency iOS app. We first start with <i>llama.cpp</i> setup and finally go to building our own SwiftUI iOS app</p>

## llama.cpp setup

<p>First things first, we had to install <i>llama.cpp</i> inference on macOS. For this, we need to clone the official repo on the Mac:</p>

```bash
$ git clone --recursive https://github.com/ggml-org/llama.cpp.git && cd llama.cpp
```

<p>By running that command, we clone and go to the root directory of <i>llama.cpp</i>. We can find <b>example/llama.swiftui</b> subdirectory there. This is what we need. But before going there, we have to build Xcode framework for further use in SwiftUI iOS app. Run this command in the root directory of <i>llama.cpp</i>:</p>

```bash
$ ./build-xcframework.sh
```

<p>And that's it! We can not proceed by integrating Google Gemma 3n into the iOS app</p>