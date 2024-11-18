import Foundation

/// Represents a link to another operation, providing context or relationships between API operations.
struct LinkObject: Codable {
    let operationRef: String?
    let operationId: String?
    let parameters: [String: AnyCodable]?
    let requestBody: AnyCodable?
    let description: String?
    let server: ServerObject?

    init(operationRef: String? = nil,
         operationId: String? = nil,
         parameters: [String: AnyCodable]? = nil,
         requestBody: AnyCodable? = nil,
         description: String? = nil,
         server: ServerObject? = nil)
    {
        self.operationRef = operationRef
        self.operationId = operationId
        self.parameters = parameters
        self.requestBody = requestBody
        self.description = description
        self.server = server
    }
}
