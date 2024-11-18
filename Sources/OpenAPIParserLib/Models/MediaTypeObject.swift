import Foundation

/// Represents a media type for a request or response, including its schema and examples.
struct MediaTypeObject: Codable {
    let schema: SchemaObject?
    let example: AnyCodable?
    let examples: [String: ExampleObject]?
    let encoding: [String: EncodingObject]?

    init(schema: SchemaObject? = nil,
         example: AnyCodable? = nil,
         examples: [String: ExampleObject]? = nil,
         encoding: [String: EncodingObject]? = nil)
    {
        self.schema = schema
        self.example = example
        self.examples = examples
        self.encoding = encoding
    }
}
