import Foundation

/// Represents a schema for defining the structure and constraints of data in an OpenAPI document.
class SchemaObject: Codable {
    let title: String?
    let type: SchemaType?
    let properties: [String: SchemaObject]?
    let items: SchemaObject?
    let required: [String]?
    let description: String?
    let format: String?
    let defaultValue: AnyCodable?
    let enumValues: [AnyCodable]?
    let additionalProperties: AdditionalProperties?
    let nullable: Bool?
    let readOnly: Bool?
    let writeOnly: Bool?
    let deprecated: Bool?

    init(title: String? = nil,
         type: SchemaType? = nil,
         properties: [String: SchemaObject]? = nil,
         items: SchemaObject? = nil,
         required: [String]? = nil,
         description: String? = nil,
         format: String? = nil,
         defaultValue: AnyCodable? = nil,
         enumValues: [AnyCodable]? = nil,
         additionalProperties: AdditionalProperties? = nil,
         nullable: Bool? = nil,
         readOnly: Bool? = nil,
         writeOnly: Bool? = nil,
         deprecated: Bool? = nil)
    {
        self.title = title
        self.type = type
        self.properties = properties
        self.items = items
        self.required = required
        self.description = description
        self.format = format
        self.defaultValue = defaultValue
        self.enumValues = enumValues
        self.additionalProperties = additionalProperties
        self.nullable = nullable
        self.readOnly = readOnly
        self.writeOnly = writeOnly
        self.deprecated = deprecated
    }
}

/// Represents the possible data types for a schema.
enum SchemaType: String, Codable {
    case object
    case array
    case string
    case number
    case integer
    case boolean
}

/// Represents additional properties, which could be either a Boolean or a SchemaObject.
indirect enum AdditionalProperties: Codable {
    case boolean(Bool)
    case schema(SchemaObject)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .boolean(boolValue)
        } else if let schemaValue = try? container.decode(SchemaObject.self) {
            self = .schema(schemaValue)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid AdditionalProperties type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .boolean(boolValue):
            try container.encode(boolValue)
        case let .schema(schemaValue):
            try container.encode(schemaValue)
        }
    }
}
