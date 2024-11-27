import XCTest
@testable import OpenAPIParserLib

final class Test_CentralSequenceService: XCTestCase {
    var parser: OpenAPIParser!
    var document: OpenAPIDocument!

    /// Set up the parser and load the Central-Sequence-Service YAML.
    override func setUpWithError() throws {
        parser = OpenAPIParser()
        
        // Load YAML string from the container.
        let yamlString = OpenAPIYAMLContainer.central_sequence_service_yml
        
        // Convert YAML string to Data.
        guard let yamlData = yamlString.data(using: .utf8) else {
            XCTFail("Failed to convert YAML string to Data.")
            return
        }
        
        // Parse the document into OpenAPIDocument.
        document = try parser.parseDocument(from: yamlData, format: "yaml")
    }

    /// Example test to validate 'info' and 'paths' objects.
    func testValidateCentralSequenceSpec() throws {
        // Validate the 'info' object.
        let info = document.info // Direct access without guard let
        XCTAssertEqual(info.title, "Central Sequence Service", "Title mismatch.")
        XCTAssertEqual(info.version, "1.0.0", "Version mismatch.")

        // Validate the 'paths' object.
        let paths = document.paths // Direct access without guard let
        XCTAssertNotNil(paths["/sequences"], "Missing 'sequences' endpoint.")
    }
}
