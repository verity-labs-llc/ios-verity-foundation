import Testing
@testable import VLData

private actor Counter {
    private(set) var value = 0
    func increment() { value += 1 }
}

private enum TestError: Error {
    case boom
}

@Test
func testRunDeduplicatesConcurrentRequestsForSameKey() async throws {
    let store = InFlightRequestStore()
    let counter = Counter()

    let results = try await withThrowingTaskGroup(of: Int.self, returning: [Int].self) { group in
        for _ in 0..<8 {
            group.addTask {
                try await store.run(key: "same-key") {
                    await counter.increment()
                    try await Task.sleep(nanoseconds: 50_000_000)
                    return 123
                }
            }
        }

        var values: [Int] = []
        for try await value in group {
            values.append(value)
        }
        return values
    }

    #expect(results.count == 8)
    #expect(results.allSatisfy { $0 == 123 })
    #expect(await counter.value == 1)
}

@Test
func testRunCleansUpTaskAfterFailure() async throws {
    let store = InFlightRequestStore()
    let counter = Counter()

    do {
        let _: Int = try await store.run(key: "failure-key") {
            await counter.increment()
            throw TestError.boom
        }
        Issue.record("Expected failure")
    } catch {
        #expect(error is TestError)
    }

    let success: Int = try await store.run(key: "failure-key") {
        await counter.increment()
        return 7
    }

    #expect(success == 7)
    #expect(await counter.value == 2)
}
