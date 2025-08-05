# Gemergency app publishing

## Publishing idea

<p>After developing our app, we wanted to make Gemergency easily accessible, so that anyone could download and use it on an iPhone/iPad. However, we quickly ran into two key challenges: where should we publish the app, and how could we get Gemma 3n running on actual devices? It might sound weird, but these were real problems</p>

<p>Let me explain why this matters and what solutions we found:</p>
<ul>
    <li>Where should we publish the app? - there were no time and opportunities to publish the app on the App Store. So had to find another platform where we could distribute Gemergency. There was only one such platform - TestFlight (it's not directly App Store, but the app might still be used by users)</li>
    <li>How could we make Gemma 3n running on physical devices? - since the first Gemergency beta, there was no opportunity to run Gemma 3n on physical device. We found very interesting solution that we are going to explain below though</li>
</ul>

## TestFlight distribution

<p>After choosing the platform which was the TestFlight, we first had to set up our app a bit: change scheme type from <b>Debug</b> to <b>Release</b>, as well as adapt Gemergency for all necessary devices: iPhones with dynamic island, all other iPhones, iPads. After that, we went into the work with model...</p>

## Problem with model

<p>By default, Gemma 3n used GPU for working on device. And while working on a simulator was swift and smooth due to Apple Silicon CPU line-up, we came across that it does not work even on iPhone 16 Pro Max in real life. That was strange for us, because the newest iPhones' capabilities were made to work AI</p>

<p>We spent about 2 days to get with problem. And accidentally we found how to solve this: we found that in case of simulator, we set GPU layers to 0, so the app works smooth on simulator. But what about physical devices? Well, that' funny but physical devices used GPU layers for work</p>

<p>To change that, we just added one line of code (well, we copied that line from #if directive) in <b>LibLlama</b> controller:</p>

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

<p>And that's it! We are done! Now we could sent our app to TestFlight and distribute it via users all across Apple Ecosystem (but still via the link)</p>