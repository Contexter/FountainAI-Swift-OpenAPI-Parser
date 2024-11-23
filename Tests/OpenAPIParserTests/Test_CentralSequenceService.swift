import XCTest
@testable import OpenAPIParserLib

final class Test_CentralSequenceService: XCTestCase {

    func testParseSequenceSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Central-Sequence-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Central-Sequence-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Central Sequence Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/sequences"), "Missing '/sequences' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("SequenceObject") ?? false, "Missing 'SequenceObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testSequenceSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Central-Sequence-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Central-Sequence-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["SequenceObject"] else {
                XCTFail("SequenceObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "SequenceObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "SequenceObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("actions") ?? false, "SequenceObject schema is missing 'actions' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
