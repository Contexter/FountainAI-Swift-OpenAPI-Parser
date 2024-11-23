import XCTest
@testable import OpenAPIParserLib

final class Test_ActionService: XCTestCase {

    func testParseActionSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Action-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Action-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Action Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/actions"), "Missing '/actions' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("ActionObject") ?? false, "Missing 'ActionObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testActionSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Action-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Action-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["ActionObject"] else {
                XCTFail("ActionObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "ActionObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "ActionObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("description") ?? false, "ActionObject schema is missing 'description' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
