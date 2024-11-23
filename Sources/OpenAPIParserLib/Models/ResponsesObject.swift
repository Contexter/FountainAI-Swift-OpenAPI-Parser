import Foundation

/// Represents a collection of responses for an API operation.
struct ResponsesObject: Codable {
    let defaultResponse: ResponseObject?
    let statusResponses: [String: ResponseObject]

    init(defaultResponse: ResponseObject? = nil, statusResponses: [String: ResponseObject]) {
        self.defaultResponse = defaultResponse
        self.statusResponses = statusResponses
    }
}

/// Represents a single response for a specific status code.
struct ResponseObject: Codable {
    let description: String
    let headers: [String: HeaderObject]?
    let content: [String: MediaTypeObject]?
    let links: [String: LinkObject]?

    init(description: String,
         headers: [String: HeaderObject]? = nil,
         content: [String: MediaTypeObject]? = nil,
         links: [String: LinkObject]? = nil)
    {
        self.description = description
        self.headers = headers
        self.content = content
        self.links = links
    }
}

extension ResponsesObject {
    subscript(responseCode: String) -> ResponseObject? {
        // Assuming ResponsesObject contains a dictionary of responses
        return self.responses[responseCode]
    }
}
