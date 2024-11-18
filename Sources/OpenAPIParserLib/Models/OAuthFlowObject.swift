import Foundation

/// Represents a single OAuth2 flow, including URLs and available scopes.
struct OAuthFlowObject: Codable {
    let authorizationUrl: URL?
    let tokenUrl: URL?
    let refreshUrl: URL?
    let scopes: [String: String]

    init(authorizationUrl: URL? = nil,
         tokenUrl: URL? = nil,
         refreshUrl: URL? = nil,
         scopes: [String: String]) {
        self.authorizationUrl = authorizationUrl
        self.tokenUrl = tokenUrl
        self.refreshUrl = refreshUrl
        self.scopes = scopes
    }
}
