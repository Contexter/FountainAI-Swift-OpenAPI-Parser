import XCTest
@testable import OpenAPIParserLib

final class Test_ParaphraseService: XCTestCase {

    func testParseParaphraseSpec() {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Paraphrase-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Paraphrase-Service.yml")
            return
        }
        
        // Parse the file
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "Paraphrase Service", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            XCTAssertTrue(document.paths.contains("/paraphrases"), "Missing '/paraphrases' endpoint.")
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("ParaphraseObject") ?? false, "Missing 'ParaphraseObject' schema.")
            
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }

    func testParaphraseSchema() {
        // Load and parse the spec
        let filePath = "Sources/OpenAPIParserLib/OpenAPI/Paraphrase-Service.yml"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Paraphrase-Service.yml")
            return
        }
        
        do {
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["ParaphraseObject"] else {
                XCTFail("ParaphraseObject schema is missing.")
                return
            }
            
            XCTAssertEqual(schema.type, "object", "ParaphraseObject schema should be of type 'object'.")
            XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "ParaphraseObject schema is missing 'id' property.")
            XCTAssertTrue(schema.properties?.keys.contains("text") ?? false, "ParaphraseObject schema is missing 'text' property.")
            XCTAssertTrue(schema.properties?.keys.contains("commentary") ?? false, "ParaphraseObject schema is missing 'commentary' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
