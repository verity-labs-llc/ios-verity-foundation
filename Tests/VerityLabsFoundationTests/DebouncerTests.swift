import Testing
import VLUtilities

private actor CallCounter {
    private(set) var value = 0
    func increment() { value += 1 }
}

@Test
func testDebounceSuppressesRepeatedCallsWithinDuration() async {
    let debouncer = Debouncer()
    let counter = CallCounter()

    await debouncer.debounce(id: "search", duration: 1.0) {
        await counter.increment()
    }

    await debouncer.debounce(id: "search", duration: 1.0) {
        await counter.increment()
    }

    #expect(await counter.value == 1)
}

@Test
func testDebounceAllowsCallAfterDuration() async throws {
    let debouncer = Debouncer()
    let counter = CallCounter()

    await debouncer.debounce(id: "refresh", duration: 0.05) {
        await counter.increment()
    }

    try await Task.sleep(nanoseconds: 80_000_000)

    await debouncer.debounce(id: "refresh", duration: 0.05) {
        await counter.increment()
    }

    #expect(await counter.value == 2)
}
