import XCTest
@testable import OpenAPIParserLib

final class Test_CharacterService: XCTestCase {

    func testParseCharacterSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Character-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Character-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Character Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/characters"), "Missing '/characters' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("CharacterObject") ?? false, "Missing 'CharacterObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testCharacterSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Character-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Character-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["CharacterObject"] else {
                XCTFail("CharacterObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "CharacterObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "CharacterObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("name") ?? false, "CharacterObject schema is missing 'name' property.")
            XCTAssertTrue(schema.properties?.keys.contains("description") ?? false, "CharacterObject schema is missing 'description' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
