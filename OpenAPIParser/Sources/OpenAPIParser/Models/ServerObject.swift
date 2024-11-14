import Foundation

/// Represents a server in an OpenAPI document, specifying the base URL and optional variables.
struct ServerObject: Codable {
    let url: String
    let description: String?
    let variables: [String: ServerVariableObject]?

    init(url: String,
         description: String? = nil,
         variables: [String: ServerVariableObject]? = nil) {
        self.url = url
        self.description = description
        self.variables = variables
    }
}

/// Represents a variable for server URLs in an OpenAPI document.
struct ServerVariableObject: Codable {
    let enumValues: [String]?
    let defaultValue: String
    let description: String?

    init(enumValues: [String]? = nil,
         defaultValue: String,
         description: String? = nil) {
        self.enumValues = enumValues
        self.defaultValue = defaultValue
        self.description = description
    }
}
