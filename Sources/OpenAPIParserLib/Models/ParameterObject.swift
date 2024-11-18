import Foundation

/// Represents a parameter for an API operation, such as a query, header, path, or cookie parameter.
struct ParameterObject: Codable {
    let name: String
    let `in`: ParameterLocation
    let description: String?
    let required: Bool?
    let deprecated: Bool?
    let allowEmptyValue: Bool?
    let schema: SchemaObject?

    init(name: String,
         in location: ParameterLocation,
         description: String? = nil,
         required: Bool? = nil,
         deprecated: Bool? = nil,
         allowEmptyValue: Bool? = nil,
         schema: SchemaObject? = nil)
    {
        self.name = name
        self.in = location
        self.description = description
        self.required = required
        self.deprecated = deprecated
        self.allowEmptyValue = allowEmptyValue
        self.schema = schema
    }
}

/// Represents the location of the parameter in an API request.
enum ParameterLocation: String, Codable {
    case query
    case header
    case path
    case cookie
}
