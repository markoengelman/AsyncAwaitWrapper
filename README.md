# AsyncAwaitWrapper
- Simple wrapper that allows us to use existing asynchronous code with new Concurrency APIs.
- To read more about motivation behind it please see my article about it: https://markoengelman.com/use-swifts-async-without-breaking-the-existing-codebase/

## Code
```
class AsyncAwaitWrapper<Resource, ResourceError> where ResourceError: Error {
    typealias ResourceLoader = (_ completion: @escaping (Result<Resource, ResourceError>) -> Void) -> Void
    let loader: ResourceLoader
    
    init(loader: @escaping ResourceLoader) {
        self.loader = loader
    }
    
    func load() async -> Result<Resource, ResourceError> {
        return await withCheckedContinuation { continuation in
            loader() { result in
                continuation.resume(returning: result)
            }
        }
    }
}
```
## How to use
- For demostrantion how to use check provided Unit Tests with usage demonstration.
