import Foundation

/// Represents a tag for categorizing API operations in an OpenAPI document.
struct TagObject: Codable {
    let name: String
    let description: String?
    let externalDocs: ExternalDocumentationObject?

    init(name: String,
         description: String? = nil,
         externalDocs: ExternalDocumentationObject? = nil)
    {
        self.name = name
        self.description = description
        self.externalDocs = externalDocs
    }
}
