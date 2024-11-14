import Foundation

/// Represents external documentation for referencing additional resources in an OpenAPI document.
struct ExternalDocumentationObject: Codable {
    let description: String?
    let url: URL

    init(description: String? = nil, url: URL) {
        self.description = description
        self.url = url
    }
}
