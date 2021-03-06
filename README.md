# AsyncAwaitWrapper
- Simple wrapper that allows us to use existing asynchronous code with new Concurrency APIs.
- To read more about motivation behind it please see my article about it: https://markoengelman.com/use-swifts-async-without-breaking-the-existing-codebase/

## Code
```Swift
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
    
    func load() async throws -> Resource {
        try await withCheckedThrowingContinuation { continuation in
            loader() { result in
                switch result {
                case let .success(resource):
                    continuation.resume(returning: resource)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
```
## How to use
- Check provided [composer](AsyncAwaitTests/AsyncAwaitTests+HelpersWithUsageExample/UsersNamesLoaderComposer.swift) with demonstration how to use.
