import Testing
@testable import VLQuery

private struct PreviewOnlyValue: Sendable {}

@Test(arguments: [QueryPreviewState.loading, .failure])
func previewStatesSkipCodableFetches(state: QueryPreviewState) async throws {
    let client = QueryClient(previewState: state)
    let fetch = Fetch<Int>(key: ["preview", "codable"]) {
        Issue.record("Preview executed a fetch")
        return 42
    }
    var iterator = client.observe(fetch).makeAsyncIterator()
    let snapshot = try #require(await iterator.next())
    #expect(snapshot.status == (state == .loading ? .pending : .failure))
    #expect(snapshot.data == nil)
    #expect(snapshot.isLoading == (state == .loading))
    #expect(snapshot.isFetching == (state == .loading))
    #expect((snapshot.error as? QueryPreviewError) == (state == .failure ? .simulatedFailure : nil))
    #expect(await iterator.next() == nil)
    await #expect(throws: state == .failure ? QueryPreviewError.simulatedFailure : .loading) {
        _ = try await client.fetch(fetch)
    }
}

@Test(arguments: [QueryPreviewState.loading, .failure])
func previewStatesSkipNonCodableFetches(state: QueryPreviewState) async throws {
    let client = QueryClient(previewState: state)
    let fetch = Fetch<PreviewOnlyValue>(key: ["preview", "noncodable"]) {
        Issue.record("Preview executed a fetch")
        return PreviewOnlyValue()
    }
    var iterator = client.observe(fetch).makeAsyncIterator()
    let snapshot = try #require(await iterator.next())
    #expect(snapshot.status == (state == .loading ? .pending : .failure))
    await #expect(throws: state == .failure ? QueryPreviewError.simulatedFailure : .loading) {
        _ = try await client.fetch(fetch)
    }
}

@Test
func normalClientStillFetchesWithPreviewClientPresent() async throws {
    let previewClient = QueryClient(previewState: .failure)
    let normalClient = QueryClient()
    let fetch = Fetch<Int>(key: ["preview", "isolation"]) { 42 }
    await #expect(throws: QueryPreviewError.simulatedFailure) {
        _ = try await previewClient.fetch(fetch)
    }
    #expect(try await normalClient.fetch(fetch) == 42)
}
