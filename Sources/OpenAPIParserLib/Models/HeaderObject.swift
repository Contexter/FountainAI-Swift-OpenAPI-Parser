import Foundation

/// Represents an HTTP header in an OpenAPI document.
struct HeaderObject: Codable {
    let description: String?
    let required: Bool?
    let deprecated: Bool?
    let allowEmptyValue: Bool?
    let style: String?
    let explode: Bool?
    let schema: SchemaObject?
    let example: AnyCodable?
    let examples: [String: ExampleObject]?
    let content: [String: MediaTypeObject]?

    init(description: String? = nil,
         required: Bool? = nil,
         deprecated: Bool? = nil,
         allowEmptyValue: Bool? = nil,
         style: String? = nil,
         explode: Bool? = nil,
         schema: SchemaObject? = nil,
         example: AnyCodable? = nil,
         examples: [String: ExampleObject]? = nil,
         content: [String: MediaTypeObject]? = nil) {
        self.description = description
        self.required = required
        self.deprecated = deprecated
        self.allowEmptyValue = allowEmptyValue
        self.style = style
        self.explode = explode
        self.schema = schema
        self.example = example
        self.examples = examples
        self.content = content
    }
}
