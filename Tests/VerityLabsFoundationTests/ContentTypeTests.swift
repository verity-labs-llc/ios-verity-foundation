import Testing
import VLFiles

@Test
func testFileExtensions() {
    #expect(ContentType.jpeg.ext == "jpg")
    #expect(ContentType.webP.ext == "webp")
    #expect(ContentType.multipart.ext == "tmp")
}

@Test
func testHeaderValues() {
    #expect(ContentType.jpeg.headerValue == "image/jpeg")
    #expect(ContentType.webP.headerValue == "image/webp")
    #expect(ContentType.multipart.headerValue == "multipart/form-data")
}
