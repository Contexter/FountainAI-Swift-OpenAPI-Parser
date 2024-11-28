import XCTest
import Yams
@testable import OpenAPIParserLib

/// Focused test for validating the presence and structure of the `paths` key in an OpenAPI document.
final class Test_OpenAPIDocument_PathsOnly: XCTestCase {

    func test_OpenAPIDocument_PathsValidation() throws {
        // Example valid OpenAPI YAML
        let validYAML = """
        openapi: "3.1.0"
        info:
          title: "Valid API"
          version: "1.0.0"
        paths:
          /example:
            get:
              summary: "Example endpoint"
              responses:
                '200':
                  description: "Success"
        """

        // Example invalid OpenAPI YAML (missing 'paths' key)
        let invalidYAML = """
        openapi: "3.1.0"
        info:
          title: "Invalid API"
          version: "1.0.0"
        """

        // --- Validate a YAML with the `paths` key ---
        do {
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: validYAML)
            XCTAssertFalse(document.paths.paths.isEmpty, "The `paths` key must not be empty for a valid OpenAPI document.")
        } catch {
            XCTFail("Decoding valid YAML failed: \(error)")
        }

        // --- Validate a YAML without the `paths` key ---
        do {
            _ = try YAMLDecoder().decode(OpenAPIDocument.self, from: invalidYAML)
            XCTFail("Decoding invalid YAML succeeded, but it should fail due to missing `paths`.")
        } catch DecodingError.keyNotFound(let key, _) where key.stringValue == "paths" {
            // Expected failure for missing `paths` key
            XCTAssertTrue(true, "Decoding failed as expected due to missing `paths` key.")
        } catch {
            XCTFail("Unexpected error decoding invalid YAML: \(error)")
        }
    }
}

