import XCTest
@testable import OpenAPIParserLib

final class Test_CoreScriptManagementService: XCTestCase {
    var parser: OpenAPIParser!
    var document: OpenAPIDocument!

    // Set up and load the YAML specification
    override func setUpWithError() throws {
        parser = OpenAPIParser()

        // Load the YAML string from OpenAPIYAMLContainer
        let yamlString = OpenAPIYAMLContainer.core_script_management_service_yml

        // Convert YAML string to Data
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to convert YAML string to Data.")
            return
        }

        // Parse the document into OpenAPIDocument
        do {
            document = try parser.parseDocument(from: yamlData, format: "yaml")
        } catch {
            XCTFail("Failed to parse OpenAPI document. Error: \(error)")
            return
        }
    }

    // Validate the `info` and `paths` components
    func testValidateCoreScriptSpec() throws {
        // Validate the 'info' object
        let info = document.info
        XCTAssertEqual(info.title, "Core Script Management API", "Title mismatch.")
        XCTAssertEqual(info.version, "4.0.0", "Version mismatch.")

        // Validate the 'paths' object
        let paths = document.paths
        XCTAssertNotNil(paths["/scripts"], "Missing '/scripts' endpoint.")
        XCTAssertNotNil(paths["/scripts/{scriptId}"], "Missing '/scripts/{scriptId}' endpoint.")
    }

    // Validate the `Script` schema
    func testScriptSchema() throws {
        // Access the 'Script' schema
        guard let schemas = document.components?.schemas,
              let scriptSchema = schemas["Script"] else {
            XCTFail("Script schema is missing.")
            return
        }

        // Validate schema type
        XCTAssertEqual(scriptSchema.type?.rawValue, "object", "Script schema should be of type 'object'.")

        // Validate schema properties
        guard let properties = scriptSchema.properties else {
            XCTFail("Script schema properties are missing.")
            return
        }

        XCTAssertNotNil(properties["id"], "Property 'id' is missing.")
        XCTAssertNotNil(properties["title"], "Property 'title' is missing.")
        XCTAssertNotNil(properties["description"], "Property 'description' is missing.")
    }
}
