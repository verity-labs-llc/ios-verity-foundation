import Testing
import Foundation
import VLCache

@Test
func testInitWithTTLBuildsFutureExpiry() throws {
    let before = Date()
    let cached = CachedObject(ttlSeconds: 2, object: "value")
    let after = Date()

    let expiry = try #require(cached.expiry)

    #expect(cached.object == "value")
    #expect(expiry.timeIntervalSince(before) >= 1.8)
    #expect(expiry.timeIntervalSince(after) <= 2.2)
}
