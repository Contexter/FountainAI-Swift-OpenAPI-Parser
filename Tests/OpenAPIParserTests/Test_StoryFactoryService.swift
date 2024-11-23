import XCTest
@testable import OpenAPIParserLib

final class Test_StoryFactoryService: XCTestCase {

    func testParseStorySpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Story-Factory-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Story-Factory-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Story Factory Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/stories"), "Missing '/stories' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("StoryObject") ?? false, "Missing 'StoryObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testStorySchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Story-Factory-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Story-Factory-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["StoryObject"] else {
                XCTFail("StoryObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "StoryObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "StoryObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("title") ?? false, "StoryObject schema is missing 'title' property.")
            XCTAssertTrue(schema.properties?.keys.contains("content") ?? false, "StoryObject schema is missing 'content' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
