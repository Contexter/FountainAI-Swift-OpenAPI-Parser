import Foundation

/// Represents the request body of an API operation, specifying the content type and schema.
struct RequestBodyObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]
    let required: Bool?

    init(description: String? = nil,
         content: [String: MediaTypeObject],
         required: Bool? = nil)
    {
        self.description = description
        self.content = content
        self.required = required
    }
}
