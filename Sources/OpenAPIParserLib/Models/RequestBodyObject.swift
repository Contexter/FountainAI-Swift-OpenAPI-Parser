struct RequestBodyObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]
}
