import Foundation

/// Represents a security scheme for authenticating requests in an OpenAPI document.
struct SecuritySchemeObject: Codable {
    let type: SecuritySchemeType
    let description: String?
    let name: String?
    let `in`: SecuritySchemeLocation?
    let scheme: String?
    let bearerFormat: String?
    let flows: OAuthFlowsObject?
    let openIdConnectUrl: URL?

    init(type: SecuritySchemeType,
         description: String? = nil,
         name: String? = nil,
         in location: SecuritySchemeLocation? = nil,
         scheme: String? = nil,
         bearerFormat: String? = nil,
         flows: OAuthFlowsObject? = nil,
         openIdConnectUrl: URL? = nil)
    {
        self.type = type
        self.description = description
        self.name = name
        self.in = location
        self.scheme = scheme
        self.bearerFormat = bearerFormat
        self.flows = flows
        self.openIdConnectUrl = openIdConnectUrl
    }
}

/// Represents the type of security scheme.
enum SecuritySchemeType: String, Codable {
    case apiKey
    case http
    case oauth2
    case openIdConnect
}

/// Represents the location of the API key for `apiKey` security schemes.
enum SecuritySchemeLocation: String, Codable {
    case query
    case header
    case cookie
}
