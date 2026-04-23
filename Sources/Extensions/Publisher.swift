import Combine

public extension Publisher {
    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        self
            .map { Result<Output, Failure>.success($0) }
            .catch { Just(Result<Output, Failure>.failure($0)) }
            .eraseToAnyPublisher()
    }
}
