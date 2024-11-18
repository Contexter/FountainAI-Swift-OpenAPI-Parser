import Foundation

/// Represents XML metadata to customize XML representation of a schema in an OpenAPI document.
struct XMLObject: Codable {
    let name: String?
    let namespace: String?
    let prefix: String?
    let attribute: Bool?
    let wrapped: Bool?

    init(name: String? = nil,
         namespace: String? = nil,
         prefix: String? = nil,
         attribute: Bool? = nil,
         wrapped: Bool? = nil)
    {
        self.name = name
        self.namespace = namespace
        self.prefix = prefix
        self.attribute = attribute
        self.wrapped = wrapped
    }
}
