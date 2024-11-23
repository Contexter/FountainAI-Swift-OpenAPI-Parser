import XCTest
@testable import OpenAPIParserLib

final class OpenAPIParserTests: XCTestCase {

    func testParseValidOpenAPIDocument31() {
        let validYAML = """
        openapi: "3.1.0"
        info:
          title: Sample API
          version: 1.0.0
        paths:
          /example:
            get:
              responses:
                '200':
                  description: Success
        """
        
        let fileURL = createTemporaryFile(with: validYAML)
        let parser = OpenAPIParser()
        do {
            let document = try parser.parse(from: fileURL) // Updated argument label to `from`
            
            // Assertions for `info`
            XCTAssertEqual(document.info.title, "Sample API")
            XCTAssertEqual(document.info.version, "1.0.0")
            
            // Assertions for `paths` structure
            if let examplePath = document.paths["/example"] {
    XCTAssertNotNil(examplePath.get)
} else {
    XCTFail("Path '/example' not found in document.paths")
} // Assuming `paths` is a dictionary-like structure
            if let examplePath = document.paths["/example"] {
                XCTAssertNotNil(examplePath.get)
                XCTAssertEqual(examplePath.get?.responses["200"]?.description, "Success")
            } else {
                XCTFail("Path '/example' was not found in the parsed document")
            }
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
    
    func testParseInvalidOpenAPIDocument31() {
        let invalidYAML = """
        openapi: "3.1.0"
        info:
          title: Sample API
        """
        
        let fileURL = createTemporaryFile(with: invalidYAML)
        let parser = OpenAPIParser()
        XCTAssertThrowsError(try parser.parse(from: fileURL)) { error in // Updated argument label to `from`
            XCTAssertTrue(error is OpenAPIParserError)
        }
    }

    private func createTemporaryFile(with content: String) -> URL {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let fileURL = temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("yaml")
        
        do {
            try content.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError("Failed to create temporary file: \(error)")
        }
        
        return fileURL
    }
}
