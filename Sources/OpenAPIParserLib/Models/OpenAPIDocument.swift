struct OpenAPIDocument: Codable {
    let openapi: String // Required: OpenAPI version (e.g., "3.1.0")
    let info: InfoObject // Required: Metadata about the API
    let paths: PathsObject // Required: Holds relative paths to endpoints and their operations
    let components: ComponentsObject? // Optional: Holds reusable objects for schemas, responses, etc.
    let security: [SecurityRequirementObject]? // Optional: Global security requirements
    let tags: [TagObject]? // Optional: Documentation tags
    let externalDocs: ExternalDocumentationObject? // Optional: External documentation links

    /// Validate the document as a whole
    func validate() -> Bool {
        var isValid = true

        if openapi.isEmpty {
            print("Validation Error: 'openapi' version is required.")
            isValid = false
        }

        if info.title.isEmpty {
            print("Validation Error: 'info' object must have a non-empty title.")
            isValid = false
        }

        if !paths.validate() {
            isValid = false
        }

        return isValid
    }
}
