import XCTest
@testable import OpenAPIParserLib

final class Test_CentralSequenceService: XCTestCase {
    func testParseSequenceSpec() throws {
        // Load the OpenAPI specification file
        let filePath = "Sources/OpenAPIParserTests/Spec/OpenAPI/Central-Sequence-Service.yml"
        guard let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            XCTFail("Failed to load Central-Sequence-Service.yml")
            return
        }
        
        // Convert the file contents to Data for parsing
        guard let specData = fileContents.data(using: .utf8) else {
            XCTFail("Failed to convert file contents to Data.")
            return
        }

        do {
            // Parse the document using OpenAPIParser
            let parser = OpenAPIParser()
            guard let document = try parser.parseDocument(from: specData, format: .yaml) else {
                XCTFail("Failed to parse OpenAPI document.")
                return
            }

            // Access and validate the `info` object
            guard let info = document.info else {
                XCTFail("Info object is missing.")
                return
            }
            XCTAssertEqual(info.title, "Central Sequence Service", "Title mismatch.")
            XCTAssertEqual(info.version, "1.0.0", "Version mismatch.")

            // Access and validate the `paths` object
            guard let paths = document.paths else {
                XCTFail("Paths object is missing.")
                return
            }
            XCTAssertNotNil(paths["/sequences"], "Missing 'sequences' endpoint.")

            // Access and validate the `components` and `schemas` objects
            guard let components = document.components else {
                XCTFail("Components object is missing.")
                return
            }
            guard let schemas = components.schemas else {
                XCTFail("Schemas object is missing or incorrectly formatted.")
                return
            }
            guard let sequenceObject = schemas["SequenceObject"] else {
                XCTFail("'SequenceObject' schema is missing.")
                return
            }

            // Validate the `SequenceObject` schema
            XCTAssertEqual(sequenceObject.type, SchemaType.object, "SequenceObject schema should be of type 'object'.")
            guard let properties = sequenceObject.properties else {
                XCTFail("SequenceObject properties are missing.")
                return
            }
            XCTAssertTrue(properties.keys.contains("id"), "SequenceObject schema is missing 'id' property.")
            XCTAssertTrue(properties.keys.contains("actions"), "SequenceObject schema is missing 'actions' property.")
        } catch {
            XCTFail("Parsing failed with error: \(error)")
        }
    }
}
