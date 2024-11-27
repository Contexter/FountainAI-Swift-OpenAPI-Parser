import XCTest
@testable import OpenAPIParserLib

final class Test_PerformerService: XCTestCase {

    func testParsePerformerSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Performer-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Performer-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Performer Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/performers"), "Missing '/performers' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("PerformerObject") ?? false, "Missing 'PerformerObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testPerformerSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Performer-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Performer-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["PerformerObject"] else {
                XCTFail("PerformerObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "PerformerObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "PerformerObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("name") ?? false, "PerformerObject schema is missing 'name' property.")
            XCTAssertTrue(schema.properties?.keys.contains("role") ?? false, "PerformerObject schema is missing 'role' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
