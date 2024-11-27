import XCTest
@testable import OpenAPIParserLib

final class Test_CharacterService: XCTestCase {
    var parser: OpenAPIParser!
    var document: OpenAPIDocument!

    /// Set up the parser and load the Character-Service YAML.
    override func setUpWithError() throws {
        parser = OpenAPIParser()
        
        // Load YAML string from the container.
        let yamlString = OpenAPIYAMLContainer.character_service_yml
        
        // Convert YAML string to Data.
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to convert YAML string to Data.")
            return
        }
        
        // Parse the document into OpenAPIDocument.
        document = try parser.parseDocument(from: yamlData, format: "yaml")
    }

    func testValidateCharacterSpec() throws {
        // Validate the 'info' object.
        let info = document.info
        XCTAssertEqual(info.title, "Character Service", "Title mismatch.")
        XCTAssertEqual(info.version, "1.0.0", "Version mismatch.")

        // Validate the 'paths' object.
        XCTAssertNotNil(document.paths["/characters"], "Missing '/characters' endpoint.")

        // Validate the 'components' and 'schemas' objects.
        guard let schemas = document.components?.schemas else {
            XCTFail("Schemas object is missing.")
            return
        }
        XCTAssertTrue(schemas.keys.contains("CharacterObject"), "Missing 'CharacterObject' schema.")
    }

    func testValidateCharacterSchema() throws {
        // Validate specific schema details for 'CharacterObject'.
        guard let schemas = document.components?.schemas,
              let schema = schemas["CharacterObject"] else {
            XCTFail("CharacterObject schema is missing.")
            return
        }

        // Validate schema type safely using SchemaType's underlying representation.
        if let schemaType = schema.type?.rawValue {
            XCTAssertEqual(schemaType, "object", "CharacterObject schema should be of type 'object'.")
        } else {
            XCTFail("CharacterObject type is missing or not valid.")
        }

        // Validate schema properties.
        guard let properties = schema.properties else {
            XCTFail("CharacterObject schema properties are missing.")
            return
        }

        XCTAssertTrue(properties.keys.contains("id"), "CharacterObject schema is missing 'id' property.")
        XCTAssertTrue(properties.keys.contains("name"), "CharacterObject schema is missing 'name' property.")
        XCTAssertTrue(properties.keys.contains("description"), "CharacterObject schema is missing 'description' property.")
    }
}
