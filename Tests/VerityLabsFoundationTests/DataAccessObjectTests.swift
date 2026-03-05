import Testing
import Foundation
import VLData
import VLSharedModels

private struct TestDAO: DataAccessObject {
    let value: String
    static let sample = TestDAO(value: "sample")
}

private func assertDataAccessObjectConformance<T: DataAccessObject>(_: T.Type) {}

@Test
func testEmptyResponseMaintainsDataAccessObjectConformance() {
    assertDataAccessObjectConformance(EmptyResponse.self)
    #expect(EmptyResponse.sample == EmptyResponse())
}

@Test
func testAttributedStringSampleExists() {
    let sample = AttributedString.sample
    #expect(sample.characters.isEmpty)
}

@Test
func testArraySampleUsesElementSample() {
    let sample: [TestDAO] = .sample
    #expect(sample == [.sample])
}
