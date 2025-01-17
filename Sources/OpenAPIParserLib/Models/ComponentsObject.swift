struct ComponentsObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]?

    enum CodingKeys: String, CodingKey {
        case description, content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        content = try container.decodeIfPresent([String: MediaTypeObject].self, forKey: .content)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(content, forKey: .content)
    }

    // Auto-generated properties
    var schemas: [String: SchemaObject]? // Schema definitions
    var responses: [String: ResponseObject]? // Response objects
    var parameters: [String: ParameterObject]? // Parameter definitions
    var examples: [String: ExampleObject]? // Example definitions
    var requestBodies: [String: RequestBodyObject]? // Request body definitions
    var headers: [String: HeaderObject]? // Header definitions
    var securitySchemes: [String: SecuritySchemeObject]? // Security schemes
    var links: [String: LinkObject]? // Link definitions
    var callbacks: [String: CallbackObject]? // Callback objects
}
