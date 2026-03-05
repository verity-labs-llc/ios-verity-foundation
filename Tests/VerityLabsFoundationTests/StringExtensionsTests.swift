import Testing
import VLExtensions

@Test
func testIsEmailWithValidAddresses() {
    #expect("user@example.com".isEmail)
    #expect("john.doe+tag@sub.domain.org".isEmail)
}

@Test
func testIsEmailWithInvalidAddresses() {
    #expect(!"not-an-email".isEmail)
    #expect(!"user@domain".isEmail)
    #expect(!"@domain.com".isEmail)
    #expect(!"user@.com".isEmail)
}
