import XCTest
@testable import OpenAPIParserLib

final class Test_CoreScriptManagementService: XCTestCase {
    var parser: OpenAPIParser!
    var document: OpenAPIDocument!

    override func setUpWithError() throws {
        parser = OpenAPIParser()

        // Dynamically search for YAML matching "Core Script Management"
        let yamlFilesMirror = Mirror(reflecting: OpenAPIMYAMLContainer.self)
        let coreScriptYAML = yamlFilesMirror.children.first { (label, value) -> Bool in
            label?.contains("core_script") == true && (value as? String)?.contains("Core Script Management") == true
        }?.value as? String

        guard let yamlString = coreScriptYAML else {
            XCTFail("Core Script Management YAML not found in OpenAPIMYAMLContainer.")
            return
        }

        // Convert YAML string to Data
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to convert YAML string to Data.")
            return
        }

        // Parse YAML string into OpenAPIDocument
        document = try parser.parseDocument(from: yamlData, format: "yaml")
    }

    func testValidateScriptSpec() throws {
        // Validate the 'info' object
        let info = document.info
        XCTAssertEqual(info.title, "Core Script Management API", "Title mismatch.")
        XCTAssertEqual(info.version, "4.0.0", "Version mismatch.")

        // Validate the '/scripts' path
        XCTAssertNotNil(document.paths["/scripts"], "Missing '/scripts' endpoint.")
    }

    func testValidateSchemas() throws {
        // Validate that 'Script' schema exists
        guard let schemas = document.components?.schemas else {
            XCTFail("Schemas object is missing.")
            return
        }

        XCTAssertTrue(schemas.keys.contains("Script"), "Missing 'Script' schema.")

        // Validate 'Script' schema details
        guard let scriptSchema = schemas["Script"] else {
            XCTFail("Script schema is missing.")
            return
        }

        XCTAssertEqual(scriptSchema.type, "object", "Script schema should be of type 'object'.")
        XCTAssertNotNil(scriptSchema.properties?["title"], "Missing 'title' property in 'Script' schema.")
        XCTAssertNotNil(scriptSchema.properties?["author"], "Missing 'author' property in 'Script' schema.")
        XCTAssertNotNil(scriptSchema.properties?["sections"], "Missing 'sections' property in 'Script' schema.")
    }
}
