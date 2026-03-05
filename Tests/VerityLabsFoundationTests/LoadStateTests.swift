import Testing
import VLSharedModels

private struct TestError: Error {}

@Test
func testValueAndErrorAccessors() {
    #expect(LoadState<Int>.success(42).value == 42)
    #expect(LoadState<Int>.success(42).error == nil)

    #expect(LoadState<Int>.idle.value == nil)
    #expect(LoadState<Int>.loading.value == nil)
    #expect(LoadState<Int>.failure(TestError()).error != nil)
}

@Test
func testMapValueTransformsSuccessAndPreservesOtherStates() {
    let mappedSuccess = LoadState<Int>.success(21).mapValue { "\($0 * 2)" }
    #expect(mappedSuccess == .success("42"))

    #expect(LoadState<Int>.idle.mapValue(String.init) == .idle)
    #expect(LoadState<Int>.loading.mapValue(String.init) == .loading)
    #expect(LoadState<Int>.failure(TestError()).mapValue(String.init).error != nil)
}

@Test
func testFailureCasesAreEquatableRegardlessOfUnderlyingError() {
    struct AnotherError: Error {}
    #expect(LoadState<Int>.failure(TestError()) == LoadState<Int>.failure(AnotherError()))
}
