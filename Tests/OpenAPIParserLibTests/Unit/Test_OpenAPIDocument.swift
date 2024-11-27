import XCTest
import Yams
@testable import OpenAPIParserLib

final class Test_OpenAPIDocument: XCTestCase {

    func test_CentralSequenceService_OpenAPIDocument_ComprehensiveValidation() throws {
        // Fetch YAML content dynamically from Central_Sequence_Service
        let yamlContent = Central_Sequence_Service.yaml
        XCTAssertFalse(yamlContent.isEmpty, "YAML content in Central_Sequence_Service is empty.")

        // Ensure 'paths' key exists before decoding
        XCTAssertTrue(yamlContent.contains("paths:"), "YAML content does not contain the 'paths' key.")

        do {
            // Decode YAML into OpenAPIDocument using Yams
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: yamlContent)

            // --- Validate Core Info ---
            validateCoreInfo(document)
            validatePaths(document.paths)
            validateComponents(document.components)
            validateSecurity(document.components?.securitySchemes)
        } catch DecodingError.keyNotFound(let key, let context) {
            XCTFail("Decoding failed: Missing key '\(key.stringValue)'. Context: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            XCTFail("Decoding failed: Type mismatch for type '\(type)'. Context: \(context.debugDescription)")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }

    // --- Additional Test: Focused Validation for 'paths' Key ---
    func test_OpenAPIDocument_MustHavePaths() throws {
        // Example OpenAPI YAML with and without 'paths'
        let validYAML = """
        openapi: "3.1.0"
        info:
          title: "Valid API"
          version: "1.0.0"
        paths:
          /example:
            get:
              summary: "Example endpoint"
        """
        let invalidYAML = """
        openapi: "3.1.0"
        info:
          title: "Invalid API"
          version: "1.0.0"
        """

        // Case 1: Valid YAML with 'paths'
        do {
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: validYAML)
            XCTAssertFalse(document.paths.paths.isEmpty, "Valid YAML must have non-empty 'paths'.")
        } catch {
            XCTFail("Decoding valid YAML failed: \(error)")
        }

        // Case 2: Invalid YAML without 'paths'
        do {
            _ = try YAMLDecoder().decode(OpenAPIDocument.self, from: invalidYAML)
            XCTFail("Decoding invalid YAML succeeded, but it should fail due to missing 'paths'.")
        } catch DecodingError.keyNotFound(let key, _) where key.stringValue == "paths" {
            // Expected error
            XCTAssertTrue(true, "Decoding failed as expected due to missing 'paths'.")
        } catch {
            XCTFail("Unexpected decoding error for invalid YAML: \(error)")
        }
    }

    // Validate Core Info
    private func validateCoreInfo(_ document: OpenAPIDocument) {
        XCTAssertEqual(document.openapi, "3.1.0", "OpenAPI version mismatch.")
        XCTAssertEqual(document.info.title, "Central Sequence Service API", "Service title mismatch.")
        XCTAssertEqual(document.info.version, "4.0.0", "Service version mismatch.")
        XCTAssertFalse(document.info.description?.isEmpty ?? true, "Service description is missing or empty.")
    }

    // Validate Paths
    private func validatePaths(_ paths: PathsObject) {
        XCTAssertFalse(paths.paths.isEmpty, "The 'paths' key is empty in the OpenAPI document.")

        // Validate /sequence path
        if let sequencePath = paths.paths["/sequence"] {
            XCTAssertNotNil(sequencePath.post, "POST operation is missing for '/sequence'.")
        } else {
            XCTFail("Path '/sequence' is missing.")
        }

        // Validate /sequence/reorder path
        if let reorderPath = paths.paths["/sequence/reorder"] {
            XCTAssertNotNil(reorderPath.put, "PUT operation is missing for '/sequence/reorder'.")
        } else {
            XCTFail("Path '/sequence/reorder' is missing.")
        }

        // Validate /sequence/version path
        if let versionPath = paths.paths["/sequence/version"] {
            XCTAssertNotNil(versionPath.post, "POST operation is missing for '/sequence/version'.")
        } else {
            XCTFail("Path '/sequence/version' is missing.")
        }
    }

    // Validate Components
    private func validateComponents(_ components: ComponentsObject?) {
        guard let components = components else {
            XCTFail("Components are missing from the OpenAPI document.")
            return
        }

        // Validate SequenceRequest Schema
        if let sequenceRequestSchema = components.schemas?["SequenceRequest"] {
            XCTAssertEqual(sequenceRequestSchema.type?.rawValue, "object", "Schema 'SequenceRequest' type mismatch.")
            XCTAssertNotNil(sequenceRequestSchema.properties?["elementType"], "Property 'elementType' is missing in 'SequenceRequest' schema.")
            XCTAssertNotNil(sequenceRequestSchema.properties?["elementId"], "Property 'elementId' is missing in 'SequenceRequest' schema.")
            XCTAssertNotNil(sequenceRequestSchema.properties?["comment"], "Property 'comment' is missing in 'SequenceRequest' schema.")
        } else {
            XCTFail("Schema 'SequenceRequest' is missing.")
        }

        // Validate SequenceResponse Schema
        if let sequenceResponseSchema = components.schemas?["SequenceResponse"] {
            XCTAssertEqual(sequenceResponseSchema.type?.rawValue, "object", "Schema 'SequenceResponse' type mismatch.")
            XCTAssertNotNil(sequenceResponseSchema.properties?["sequenceNumber"], "Property 'sequenceNumber' is missing in 'SequenceResponse' schema.")
            XCTAssertNotNil(sequenceResponseSchema.properties?["comment"], "Property 'comment' is missing in 'SequenceResponse' schema.")
        } else {
            XCTFail("Schema 'SequenceResponse' is missing.")
        }
    }

    // Validate Security Schemes
    private func validateSecurity(_ securitySchemes: [String: SecuritySchemeObject]?) {
        guard let securitySchemes = securitySchemes, let apiKeyAuth = securitySchemes["apiKeyAuth"] else {
            XCTFail("Security scheme 'apiKeyAuth' is missing.")
            return
        }

        XCTAssertEqual(apiKeyAuth.type.rawValue, "apiKey", "Security scheme 'apiKeyAuth' type mismatch.")
        XCTAssertEqual(apiKeyAuth.name, "X-API-KEY", "Security scheme 'apiKeyAuth' name mismatch.")
        XCTAssertEqual(apiKeyAuth.`in`?.rawValue, "header", "Security scheme 'apiKeyAuth' location mismatch.")
    }
}
