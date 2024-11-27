import XCTest
import Yams
@testable import OpenAPIParserLib

final class Test_OpenAPIDocument: XCTestCase {

    func test_ActionService_OpenAPIDocument_ComprehensiveValidation() throws {
        // Fetch YAML content dynamically from Action_Service
        let yamlContent = Action_Service.yaml
        XCTAssertFalse(yamlContent.isEmpty, "YAML content in Action_Service is empty.")

        // Ensure 'paths' key exists before decoding
        XCTAssertTrue(yamlContent.contains("paths:"), "YAML content does not contain the 'paths' key.")

        do {
            // Decode YAML into OpenAPIDocument using Yams
            let document = try YAMLDecoder().decode(OpenAPIDocument.self, from: yamlContent)

            // --- Validate Core Info ---
            XCTAssertEqual(document.openapi, "3.1.0", "OpenAPI version mismatch.")
            XCTAssertEqual(document.info.title, "Action Service", "Service title mismatch.")
            XCTAssertEqual(document.info.version, "4.0.0", "Service version mismatch.")
            XCTAssertFalse(document.info.description?.isEmpty ?? true, "Service description is missing or empty.")

            // --- Validate Paths ---
            XCTAssertFalse(document.paths.paths.isEmpty, "The 'paths' key is empty in the OpenAPI document.")
            if let actionsPath = document.paths.paths["/actions"] {
                XCTAssertNotNil(actionsPath.get, "GET operation is missing for '/actions'.")
                XCTAssertNotNil(actionsPath.post, "POST operation is missing for '/actions'.")
            } else {
                XCTFail("Path '/actions' is missing.")
            }

            if let actionsByIdPath = document.paths.paths["/actions/{actionId}"] {
                XCTAssertNotNil(actionsByIdPath.get, "GET operation is missing for '/actions/{actionId}'.")
                XCTAssertNotNil(actionsByIdPath.patch, "PATCH operation is missing for '/actions/{actionId}'.")
                XCTAssertNotNil(actionsByIdPath.delete, "DELETE operation is missing for '/actions/{actionId}'.")
            } else {
                XCTFail("Path '/actions/{actionId}' is missing.")
            }

            // --- Validate Components ---
            guard let components = document.components else {
                XCTFail("Components are missing from the OpenAPI document.")
                return
            }

            // Validate Action Schema
            if let actionSchema = components.schemas?["Action"] {
                if let schemaType = actionSchema.type {
                    XCTAssertEqual(schemaType.rawValue, "object", "Schema 'Action' type mismatch.")
                } else {
                    XCTFail("Schema 'Action' type is missing.")
                }
                XCTAssertNotNil(actionSchema.properties?["actionId"], "Property 'actionId' is missing in 'Action' schema.")
                XCTAssertNotNil(actionSchema.properties?["description"], "Property 'description' is missing in 'Action' schema.")
                XCTAssertNotNil(actionSchema.properties?["characterId"], "Property 'characterId' is missing in 'Action' schema.")
            } else {
                XCTFail("Schema 'Action' is missing.")
            }

            // Validate ActionCreateRequest Schema
            if let actionCreateSchema = components.schemas?["ActionCreateRequest"] {
                if let schemaType = actionCreateSchema.type {
                    XCTAssertEqual(schemaType.rawValue, "object", "Schema 'ActionCreateRequest' type mismatch.")
                } else {
                    XCTFail("Schema 'ActionCreateRequest' type is missing.")
                }
                XCTAssertNotNil(actionCreateSchema.properties?["description"], "Property 'description' is missing in 'ActionCreateRequest' schema.")
                XCTAssertNotNil(actionCreateSchema.properties?["characterId"], "Property 'characterId' is missing in 'ActionCreateRequest' schema.")
            } else {
                XCTFail("Schema 'ActionCreateRequest' is missing.")
            }

            // --- Validate Security ---
            if let securitySchemes = components.securitySchemes, let apiKeyAuth = securitySchemes["apiKeyAuth"] {
                XCTAssertEqual(apiKeyAuth.type.rawValue, "apiKey", "Security scheme 'apiKeyAuth' type mismatch.")
                XCTAssertEqual(apiKeyAuth.name, "X-API-KEY", "Security scheme 'apiKeyAuth' name mismatch.")
                if let location = apiKeyAuth.`in` {
                    XCTAssertEqual(location.rawValue, "header", "Security scheme 'apiKeyAuth' location mismatch.")
                } else {
                    XCTFail("Security scheme 'apiKeyAuth' location is missing.")
                }
            } else {
                XCTFail("Security scheme 'apiKeyAuth' is missing.")
            }

        } catch DecodingError.keyNotFound(let key, let context) {
            XCTFail("Decoding failed: Missing key '\(key.stringValue)'. Context: \(context.debugDescription)")
        } catch DecodingError.typeMismatch(let type, let context) {
            XCTFail("Decoding failed: Type mismatch for type '\(type)'. Context: \(context.debugDescription)")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
