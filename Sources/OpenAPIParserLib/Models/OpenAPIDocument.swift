import Foundation

/// Represents the root object of an OpenAPI document.
struct OpenAPIDocument: Codable {
    let openapi: String // Required: OpenAPI version (e.g., "3.1.0")
    let info: InfoObject // Required: Metadata about the API
    let paths: PathsObject // Required: Holds relative paths to endpoints and their operations
    let components: ComponentsObject? // Optional: Holds reusable objects for schemas, responses, etc.
    let security: [SecurityRequirementObject]? // Optional: Global security requirements
    let tags: [TagObject]? // Optional: Documentation tags
    let externalDocs: ExternalDocumentationObject? // Optional: External documentation links

    /// Validates the OpenAPI document to ensure it adheres to basic OpenAPI structure rules.
    /// - Returns: `true` if the document is valid; otherwise, `false`.
    func validate() -> Bool {
        var isValid = true

        // Validate `openapi` field
        if openapi.isEmpty {
            print("Validation Error: 'openapi' version is required.")
            isValid = false
        }

        // Validate `info` object
        if info.title.isEmpty {
            print("Validation Error: 'info' object must have a non-empty title.")
            isValid = false
        }

        // Validate `paths` object
        if paths.paths.isEmpty {
            print("Validation Error: 'paths' object must have at least one path.")
            isValid = false
        }

        return isValid
    }
}
