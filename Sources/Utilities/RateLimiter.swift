import Dependencies
import Foundation

public protocol RateLimiter: Sendable {
    func limit(_ request: String, delay: Duration, block: @escaping @Sendable () async throws -> Void) async throws
}

public actor RateLimiterLiveValue: RateLimiter {
    private var requestIds = [String: UUID]()

    public init() {}

    public func limit(_ request: String, delay: Duration, block: @escaping @Sendable () async throws -> Void) async throws {
        let requestId = UUID()
        requestIds[request] = requestId
        try await Task.sleep(for: delay)

        if requestIds[request] == requestId {
            try await block()
        }
    }
}

public enum RateLimiterKey: DependencyKey {
    public static let liveValue: RateLimiter = RateLimiterLiveValue()
}

public extension DependencyValues {
    var rateLimiter: RateLimiter {
        get { self[RateLimiterKey.self] }
        set { self[RateLimiterKey.self] = newValue }
    }
}
