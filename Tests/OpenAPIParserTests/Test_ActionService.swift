import XCTest
@testable import OpenAPIParserLib

/// Tests for the `Action-Service.yml` OpenAPI specification.
/// These tests validate both the structure of the parsed document and specific details about schemas and paths.
/// The goal is to ensure that the OpenAPI parser interprets the YAML file correctly and that the document aligns with the expected API functionality.
final class Test_ActionService: XCTestCase {
    var parser: OpenAPIParser! // Instance of the parser used in all tests.
    var document: OpenAPIDocument! // Parsed OpenAPI document for the Action Service.

    /// Setup method to prepare the parser and load the OpenAPI spec before each test.
    /// This avoids redundant code in individual tests and ensures consistency.
    override func setUpWithError() throws {
        parser = OpenAPIParser()
        
        // Locate and load the `Action-Service.yml` file from the resources directory.
        // The file defines the API contract for the Action Service, including endpoints, schemas, and metadata.
        let fileURL = Bundle.module.url(forResource: "Action-Service", withExtension: "yml")!
        let specData = try String(contentsOf: fileURL, encoding: .utf8)
        
        // Parse the YAML file into an `OpenAPIDocument` object.
        // This object represents the structure and content of the OpenAPI specification.
        document = try parser.parse(from: specData, format: <#String#>)
    }

    /// Validates the basic structure of the `Action-Service.yml` document.
    /// Ensures that core components such as metadata, paths, and schemas are present and correctly parsed.
    func testParseActionSpec() throws {
        // The `info` object contains metadata about the API, such as its title and version.
        XCTAssertEqual(document.info.title, "Action Service", "The API title does not match the expected value.")
        XCTAssertEqual(document.info.version, "1.0.0", "The API version does not match the expected value.")
        
        // The `paths` object defines the available endpoints in the API.
        // Here, we assert that the `/actions` endpoint is correctly included in the parsed document.
        XCTAssertTrue(document.paths.contains("/actions"), "The '/actions' endpoint is missing in the API specification.")
        
        // The `components` object holds reusable definitions such as schemas.
        // We verify that the `ActionObject` schema, which defines the structure of an action, is present.
        XCTAssertNotNil(document.components?.schemas, "The components section is missing or empty.")
        XCTAssertTrue(document.components?.schemas?.keys.contains("ActionObject") ?? false, "The 'ActionObject' schema is missing from the components.")
    }

    /// Tests the structure of the `ActionObject` schema defined in the `Action-Service.yml` file.
    /// The `ActionObject` schema describes the structure of an individual action, including required fields.
    func testActionSchema() throws {
        // Retrieve the `ActionObject` schema from the parsed document.
        // This schema is expected to be a JSON object with specific properties.
        guard let schema = document.components?.schemas?["ActionObject"] else {
            XCTFail("The 'ActionObject' schema is missing from the components.")
            return
        }
        
        // Assert that the schema type is `object`, indicating that it represents a JSON object.
        XCTAssertEqual(schema.type, "object", "The 'ActionObject' schema should be of type 'object'.")
        
        // Verify that the schema includes the required properties `id` and `description`.
        // These properties are essential for identifying and describing actions.
        XCTAssertTrue(schema.properties?.keys.contains("id") ?? false, "The 'ActionObject' schema is missing the 'id' property.")
        XCTAssertTrue(schema.properties?.keys.contains("description") ?? false, "The 'ActionObject' schema is missing the 'description' property.")
    }

    /// Validates the round-trip consistency of parsing and serialization for the `Action-Service.yml` document.
    /// Ensures that the document can be parsed, serialized back to YAML, and then re-parsed without losing information.
    func testRoundTripSerialization() throws {
        // Serialize the `OpenAPIDocument` back to YAML using the `serializeToYAML` method.
        let yamlString = try parser.serializeToYAML(document: document)
        
        // Re-parse the serialized YAML string to ensure consistency with the original document.
        let reParsedDocument = try parser.parse(from: <#Data#>, format: yamlString)
        
        // Verify that critical information, such as the title, remains unchanged after the round trip.
        XCTAssertEqual(reParsedDocument.info.title, document.info.title, "The title does not match after round-trip serialization.")
        
        // Ensure that the endpoints (paths) remain intact and correctly parsed.
        XCTAssertEqual(reParsedDocument.paths.keys, document.paths.keys, "The paths do not match after round-trip serialization.")
    }
}
