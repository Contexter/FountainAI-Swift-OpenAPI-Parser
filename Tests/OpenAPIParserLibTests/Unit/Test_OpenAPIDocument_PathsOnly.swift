import XCTest
import Yams
@testable import OpenAPIParserLib

/// Focused test for validating the presence and structure of the `paths` key in an OpenAPI document.
final class Test_OpenAPIDocument_PathsOnly: XCTestCase {

    func test_OpenAPIDocument_PathsValidation() throws {
        // Valid YAML from Central_Sequence_Service
        let validYAML = Central_Sequence_Service.yaml
        XCTAssertFalse(validYAML.isEmpty, "YAML content in Central_Sequence_Service is empty.")

        do {
            // Decode valid YAML
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: validYAML)
            XCTAssertFalse(document.paths.paths.isEmpty, "The `paths` key must not be empty in a valid OpenAPI document.")

            // Validate specific paths
            if let sequencePath = document.paths.paths["/sequence"] {
                XCTAssertNotNil(sequencePath.post, "POST operation is missing for '/sequence'.")
            } else {
                XCTFail("Path '/sequence' is missing in the OpenAPI document.")
            }
        } catch {
            XCTFail("Decoding valid YAML failed: \(error)")
        }

        // Invalid YAML from Malformed_OpenAPI
        let invalidYAML = Malformed_OpenAPI.yamlMissingPaths

        do {
            // Attempt to decode invalid YAML
            _ = try YAMLDecoder().decode(OpenAPIDocument.self, from: invalidYAML)
            XCTFail("Decoding invalid YAML succeeded, but it should fail due to missing `paths`.")
        } catch DecodingError.keyNotFound(let key, _) where key.stringValue == "paths" {
            XCTAssertTrue(true, "Decoding failed as expected due to missing `paths` key.")
        } catch {
            XCTFail("Unexpected error decoding invalid YAML: \(error)")
        }
    }
}
