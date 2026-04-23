// semaphores allow us to limit the amount of operations that run at the same time
public actor AsyncSemaphore {
    private let maxConcurrent: Int
    private var currentCount = 0
    private var waitQueue: [CheckedContinuation<Void, Never>] = []

    public init(maxConcurrent: Int) {
        self.maxConcurrent = maxConcurrent
    }

    public func acquire() async {
        if currentCount < maxConcurrent {
            currentCount += 1
            return
        }

        await withCheckedContinuation { continuation in
            waitQueue.append(continuation)
        }
    }

    public func release() {
        if !waitQueue.isEmpty {
            let continuation = waitQueue.removeFirst()
            continuation.resume()
        } else {
            currentCount = max(currentCount - 1, 0)
        }
    }
}
