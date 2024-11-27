import XCTest
@testable import OpenAPIParserLib

final class Test_SpokenWordService: XCTestCase {

    func testParseSpokenWordSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Spoken-Word-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Spoken-Word-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Spoken Word Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/spoken-words"), "Missing '/spoken-words' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("SpokenWordObject") ?? false, "Missing 'SpokenWordObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testSpokenWordSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Spoken-Word-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Spoken-Word-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["SpokenWordObject"] else {
                XCTFail("SpokenWordObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "SpokenWordObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "SpokenWordObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("text") ?? false, "SpokenWordObject schema is missing 'text' property.")
            XCTAssertTrue(schema.properties?.keys.contains("sequence") ?? false, "SpokenWordObject schema is missing 'sequence' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
