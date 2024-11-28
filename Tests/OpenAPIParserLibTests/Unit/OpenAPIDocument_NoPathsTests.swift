import XCTest
import Yams
@testable import OpenAPIParserLib

/// Test suite for verifying the behavior of the OpenAPIDocument parser when the `paths` object is missing.
final class OpenAPIDocument_NoPathsTests: XCTestCase {

    /// Tests that an OpenAPI document without the `paths` key fails to decode.
    func test_OpenAPIDocument_MissingPathsKey_ParsingFails() throws {
        // Fetch malformed YAML from the Malformed_OpenAPI container
        // This YAML omits the `paths` key entirely.
        let yamlWithoutPaths = Malformed_OpenAPI.yamlMissingPaths
        XCTAssertFalse(yamlWithoutPaths.isEmpty, "Error: Malformed YAML content is unexpectedly empty.")

        // Attempt to decode the malformed YAML
        do {
            _ = try YAMLDecoder().decode(OpenAPIDocument.self, from: yamlWithoutPaths)
            XCTFail("Decoding succeeded, but it should fail because the `paths` key is missing.")
        } catch DecodingError.keyNotFound(let key, _) where key.stringValue == "paths" {
            // Expect decoding to fail due to the missing `paths` key
            XCTAssertTrue(true, "Decoding failed as expected due to missing `paths` key.")
        } catch {
            XCTFail("Unexpected error decoding malformed YAML: \(error)")
        }
    }

    /// Tests the parser's error message when `paths` is empty in the YAML document.
    func test_OpenAPIDocument_EmptyPathsObject_ParsingFails() throws {
        // Fetch malformed YAML from Malformed_OpenAPI container
        // This YAML defines `paths` but leaves it empty.
        let yamlWithEmptyPaths = Malformed_OpenAPI.yamlEmptyPaths
        XCTAssertFalse(yamlWithEmptyPaths.isEmpty, "Error: Malformed YAML content is unexpectedly empty.")

        // Attempt to decode the malformed YAML
        do {
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: yamlWithEmptyPaths)

            // Validate that the paths object is decoded but contains no entries
            XCTAssertTrue(document.paths.paths.isEmpty, "Error: Decoded `paths` should be empty, but it contains entries.")
        } catch {
            XCTFail("Unexpected error decoding YAML with empty `paths`: \(error)")
        }
    }
}

