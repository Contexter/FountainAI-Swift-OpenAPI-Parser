import Foundation

/// Represents the available OAuth2 flows for a security scheme.
struct OAuthFlowsObject: Codable {
    let implicit: OAuthFlowObject?
    let password: OAuthFlowObject?
    let clientCredentials: OAuthFlowObject?
    let authorizationCode: OAuthFlowObject?

    init(implicit: OAuthFlowObject? = nil,
         password: OAuthFlowObject? = nil,
         clientCredentials: OAuthFlowObject? = nil,
         authorizationCode: OAuthFlowObject? = nil)
    {
        self.implicit = implicit
        self.password = password
        self.clientCredentials = clientCredentials
        self.authorizationCode = authorizationCode
    }
}
