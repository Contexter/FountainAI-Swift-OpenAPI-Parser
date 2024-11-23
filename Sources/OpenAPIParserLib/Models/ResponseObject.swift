struct ResponseObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]?
}

struct MediaTypeObject: Codable {
    let schema: SchemaObject?
}
