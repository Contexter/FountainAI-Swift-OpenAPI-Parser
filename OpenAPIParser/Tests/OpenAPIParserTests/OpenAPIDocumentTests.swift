import XCTest
@testable import OpenAPIParser

final class OpenAPIDocumentTests: XCTestCase {

    func testValidOpenAPIDocument() {
        // Example valid data for OpenAPIDocument
        let info = InfoObject(title: "Action Service", description: "This is a test API", version: "1.0.0")
        let paths = PathsObject(paths: ["/test": OpenAPIPathItemObject()])

        let document = OpenAPIDocument(
            openapi: "3.0.1",
            info: info,
            paths: paths
        )

        XCTAssertTrue(document.validate(), "The OpenAPIDocument should be valid.")
    }

    func testInvalidOpenAPIDocument_NoOpenAPIVersion() {
        let info = InfoObject(title: "Action Service", description: "This is a test API", version: "1.0.0")
        let paths = PathsObject(paths: ["/test": OpenAPIPathItemObject()])

        let document = OpenAPIDocument(
            openapi: "",
            info: info,
            paths: paths
        )

        XCTAssertFalse(document.validate(), "The OpenAPIDocument should be invalid due to missing OpenAPI version.")
    }

    func testInvalidOpenAPIDocument_NoPaths() {
        let info = InfoObject(title: "Action Service", description: "This is a test API", version: "1.0.0")
        
        let document = OpenAPIDocument(
            openapi: "3.0.1",
            info: info,
            paths: PathsObject(paths: [:]) // Empty paths dictionary
        )

        XCTAssertFalse(document.validate(), "The OpenAPIDocument should be invalid due to empty paths.")
    }
}
