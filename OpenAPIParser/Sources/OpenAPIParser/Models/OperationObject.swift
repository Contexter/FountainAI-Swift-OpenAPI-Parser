import Foundation

/// Represents a single API operation on a path, such as GET, POST, DELETE, etc.
struct OperationObject: Codable {
    let tags: [String]?
    let summary: String?
    let description: String?
    let externalDocs: ExternalDocumentationObject?
    let operationId: String?
    let parameters: [ParameterObject]?
    let requestBody: RequestBodyObject?
    let responses: ResponsesObject
    let deprecated: Bool?
    let security: [SecurityRequirementObject]?
    let servers: [ServerObject]?
    
    init(tags: [String]? = nil,
         summary: String? = nil,
         description: String? = nil,
         externalDocs: ExternalDocumentationObject? = nil,
         operationId: String? = nil,
         parameters: [ParameterObject]? = nil,
         requestBody: RequestBodyObject? = nil,
         responses: ResponsesObject,
         deprecated: Bool? = nil,
         security: [SecurityRequirementObject]? = nil,
         servers: [ServerObject]? = nil) {
        self.tags = tags
        self.summary = summary
        self.description = description
        self.externalDocs = externalDocs
        self.operationId = operationId
        self.parameters = parameters
        self.requestBody = requestBody
        self.responses = responses
        self.deprecated = deprecated
        self.security = security
        self.servers = servers
    }
}
