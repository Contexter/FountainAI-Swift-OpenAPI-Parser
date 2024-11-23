import XCTest
@testable import OpenAPIParserLib

final class Test_CoreScriptManagementService: XCTestCase {

    func testParseScriptSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Core-Script-Managment-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Core-Script-Managment-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Core Script Management Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/scripts"), "Missing '/scripts' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("ScriptObject") ?? false, "Missing 'ScriptObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testScriptSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Core-Script-Managment-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Core-Script-Managment-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["ScriptObject"] else {
                XCTFail("ScriptObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "ScriptObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "ScriptObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("title") ?? false, "ScriptObject schema is missing 'title' property.")
            XCTAssertTrue(schema.properties?.keys.contains("content") ?? false, "ScriptObject schema is missing 'content' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
