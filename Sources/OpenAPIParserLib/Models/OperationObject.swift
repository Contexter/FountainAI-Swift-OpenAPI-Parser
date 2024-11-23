struct OperationObject: Codable {
    let tags: [String]?
    let summary: String?
    let operationId: String?
    let parameters: [ParameterObject]?
    let requestBody: RequestBodyObject?
    let responses: ResponsesObject
    let deprecated: Bool?
    let security: [SecurityRequirementObject]?

    enum CodingKeys: String, CodingKey {
        case tags, summary, operationId, parameters, requestBody, responses, deprecated, security
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        operationId = try container.decodeIfPresent(String.self, forKey: .operationId)
        parameters = try container.decodeIfPresent([ParameterObject].self, forKey: .parameters)
        requestBody = try container.decodeIfPresent(RequestBodyObject.self, forKey: .requestBody)
        responses = try container.decode(ResponsesObject.self, forKey: .responses)
        deprecated = try container.decodeIfPresent(Bool.self, forKey: .deprecated)
        security = try container.decodeIfPresent([SecurityRequirementObject].self, forKey: .security)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encodeIfPresent(operationId, forKey: .operationId)
        try container.encodeIfPresent(parameters, forKey: .parameters)
        try container.encodeIfPresent(requestBody, forKey: .requestBody)
        try container.encode(responses, forKey: .responses)
        try container.encodeIfPresent(deprecated, forKey: .deprecated)
        try container.encodeIfPresent(security, forKey: .security)
    }
}
