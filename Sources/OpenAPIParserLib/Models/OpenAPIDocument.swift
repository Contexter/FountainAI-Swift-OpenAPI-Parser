import Foundation

/// The root object of an OpenAPI document, representing the main structure of the API definition.
struct OpenAPIDocument: Codable {
    let openapi: String // Required: OpenAPI version (e.g., "3.0.1").
    let info: InfoObject // Required: Provides metadata about the API.
    let paths: PathsObject // Required: Holds the relative paths to the individual endpoints and their operations.
    let components: ComponentsObject? // Optional: Holds a set of reusable objects for different aspects of the API.
    let security: [SecurityRequirementObject]? // Optional: Defines a global security scheme applied to all operations.
    let tags: [TagObject]? // Optional: A list of tags used by the API for documentation purposes.
    let externalDocs: ExternalDocumentationObject? // Optional: Additional external documentation for this API.

    init(
        openapi: String,
        info: InfoObject,
        paths: PathsObject,
        components: ComponentsObject? = nil,
        security: [SecurityRequirementObject]? = nil,
        tags: [TagObject]? = nil,
        externalDocs: ExternalDocumentationObject? = nil
    ) {
        self.openapi = openapi
        self.info = info
        self.paths = paths
        self.components = components
        self.security = security
        self.tags = tags
        self.externalDocs = externalDocs
    }

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
        if !ValidationUtility.validateNonEmptyString(info.title) {
            print("Validation Error: 'info' object must have a non-empty title.")
            isValid = false
        }

        // Validate `paths` object
        if paths.paths.isEmpty {
            print("Validation Error: 'paths' object must have at least one path.")
            isValid = false
        }

        // Validate each schema within components (if components are present)
        if let components = components {
            if let schemas = components.schemas {
                for (key, schema) in schemas {
                    if !ValidationUtility.validateSchema(schema) {
                        print("Validation Error: Invalid schema for key '\(key)' in components.")
                        isValid = false
                    }
                }
            }
            // Additional validations for responses, parameters, etc., can be added here.
        }

        return isValid
    }
}
