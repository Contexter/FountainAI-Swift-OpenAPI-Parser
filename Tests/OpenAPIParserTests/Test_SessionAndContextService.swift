import XCTest
@testable import OpenAPIParserLib

final class Test_SessionAndContextService: XCTestCase {

    func testParseSessionSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Session-And-Context-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Session-And-Context-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Session And Context Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/sessions"), "Missing '/sessions' endpoint.")
            XCTAssertTrue(document.paths.contains("/contexts"), "Missing '/contexts' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("SessionObject") ?? false, "Missing 'SessionObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testSessionSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Session-And-Context-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Session-And-Context-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["SessionObject"] else {
                XCTFail("SessionObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "SessionObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "SessionObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("context") ?? false, "SessionObject schema is missing 'context' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
