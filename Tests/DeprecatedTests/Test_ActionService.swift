import XCTest
@testable import OpenAPIParserLib

/// Test cases for the Action-Service OpenAPI document.
final class Test_ActionService: XCTestCase {
    var parser: OpenAPIParser!
    var document: OpenAPIDocument!

    /// Set up the parser and load the Action-Service YAML.
    override func setUpWithError() throws {
        parser = OpenAPIParser()
        
        // Load YAML string from the container.
        let yamlString = OpenAPIYAMLContainer.action_service_yml
        
        // Convert YAML string to Data.
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to convert YAML string to Data.")
            return
        }
        
        // Parse the document into OpenAPIDocument.
        document = try parser.parseDocument(from: yamlData, format: "yaml")
    }

    /// Validate the schema for `ActionObject`.
    func testActionSchema() throws {
        // Access schema for 'ActionObject'.
        guard let actionObject = document.components?.schemas?["ActionObject"] else {
            XCTFail("The 'ActionObject' schema is missing from the components.schemas.")
            return
        }
        
        // Assert that the schema type is 'object'.
        XCTAssertEqual(actionObject.type?.rawValue, "object", "The 'ActionObject' schema should be of type 'object'.")
        
        // Verify required properties exist.
        guard let properties = actionObject.properties else {
            XCTFail("The 'ActionObject.properties' section is missing or improperly parsed.")
            return
        }
        XCTAssertTrue(properties.keys.contains("id"), "The 'ActionObject' schema is missing the 'id' property.")
        XCTAssertTrue(properties.keys.contains("description"), "The 'ActionObject' schema is missing the 'description' property.")
    }

    /// Validate round-trip consistency of serialization and parsing.
    func testRoundTripSerialization() throws {
        // Serialize the document back to YAML.
        guard let yamlString = try? parser.serializeToYAML(document: document) else {
            XCTFail("Failed to serialize the document to YAML.")
            return
        }
        XCTAssertFalse(yamlString.isEmpty, "Serialized YAML string is empty.")
        
        // Convert YAML string to Data.
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to generate YAML data from serialized string.")
            return
        }
        
        // Re-parse serialized YAML.
        guard let reParsedDocument = try? parser.parseDocument(from: yamlData, format: "yaml") else {
            XCTFail("Failed to parse the serialized YAML back to a document.")
            return
        }
        
        // Verify round-trip consistency for 'info' section.
        XCTAssertEqual(reParsedDocument.info.title, document.info.title, "The title does not match after round-trip serialization.")
        
        // Verify round-trip consistency for 'paths' section.
        XCTAssertTrue(reParsedDocument.paths["/actions"] != nil, "The '/actions' endpoint is missing after round-trip serialization.")
    }
}
