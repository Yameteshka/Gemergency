# Setting up an iOS app with Gemma 3n

## Preparation

<p>We were ready to build a brand new SwiftUI iOS app. Before we began, we had to set up the <b>Xcode framework</b> within the app. To start, we created a new SwiftUI project in Xcode by navigating to <b>Xcode → File → New → Project</b>, selecting SwiftUI as the primary UI framework, and creating a new app</p>

<p>Next, we had to add the <b>Xcode framework</b> we built earlier to the project. This can be done easily by simply dragging and dropping the framework into our app. Once that's done, we could move on to integrating the necessary controllers into the app</p>

## App setup

<p>To work successfully with Gemma 3n, our SwiftUI iOS app requires two key controllers: <b>LlamaState</b> and <b>LibLlama</b>. Both can be found in <b>llama.cpp/examples/llama.swiftui</b>:</p>
<ul>
    <li><b>LlamaState</b> - acts as a bridge between the SwiftUI app and <i>llama.cpp</i>, using <b>LibLlama</b></li>
    <li><b>LibLlama</b> - serves as the core engine that manages LLM setup within the SwiftUI app</li>
</ul>
<p>After adding these controllers to our SwiftUI project, we were ready to begin designing the app's user interface</p>

## Additional features to controllers

<p>In addition to adding these controllers to the project, we also needed to modify them to ensure they functioned correctly</p>
<p>First things first, we had to add these lines of code into <b>LibLlama</b>:</p>

```swift
func clear() {
    tokens_list.removeAll()
    temporary_invalid_cchars.removeAll()
    llama_memory_clear(llama_get_memory(context), true)

    self.n_cur = 0 // <- add this line
    self.is_done = false // <- add this line
}
```

<p>Without these lines of code, Gemma 3n won't respond to a second prompt. To clarify: the first prompt works as expected and receives a response, but the second prompt fails because the session cache isn't cleared between prompts.</p>

```swift
static func create_context(path: String) throws -> LlamaContext {
    llama_backend_init()
    var model_params = llama_model_default_params() // <- add this line

#if targetEnvironment(simulator)
    model_params.n_gpu_layers = 0
    print("Running on simulator, force use n_gpu_layers = 0")
#endif
    model_params.n_gpu_layers = 0 // <- add this line

    let model = llama_model_load_from_file(path, model_params)
    guard let model else {
        print("Could not load model at \(path)")
        throw LlamaError.couldNotInitializeContext
    }

    let n_threads = max(1, min(8, ProcessInfo.processInfo.processorCount - 2))
    print("Using \(n_threads) threads")

    var ctx_params = llama_context_default_params()
    ctx_params.n_ctx = 2048
    ctx_params.n_threads       = Int32(n_threads)
    ctx_params.n_threads_batch = Int32(n_threads)

    let context = llama_init_from_model(model, ctx_params)
    guard let context else {
        print("Could not load context!")
        throw LlamaError.couldNotInitializeContext
    }

    return LlamaContext(model: model, context: context)
}
```

<p>Without these lines of code, the model won't load on physical devices. It may run successfully from within Xcode, it will fail to work — such as when distributed via TestFlight — on any actual device though</p>
<p>Other necessary settings and methods can be found on <a href="https://github.com/charming-whaley/gemergency_ios_app_code">Github repo of Gemergency</a></p>

## Further steps

<p>With that completed, we proceeded to develop the Gemergency iOS app. The next steps involved designing the UI with SwiftUI, integrating iOS system features, and implementing other core functionalities</p>
