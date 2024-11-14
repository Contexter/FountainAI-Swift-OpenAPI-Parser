import Foundation

/// Represents a discriminator object for supporting polymorphism in OpenAPI schemas.
struct DiscriminatorObject: Codable {
    let propertyName: String
    let mapping: [String: String]?

    init(propertyName: String, mapping: [String: String]? = nil) {
        self.propertyName = propertyName
        self.mapping = mapping
    }
}
