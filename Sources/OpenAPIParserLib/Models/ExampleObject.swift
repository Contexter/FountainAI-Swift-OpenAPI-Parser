import Foundation

/// Represents an example value for schemas, parameters, or responses in an OpenAPI document.
struct ExampleObject: Codable {
    let summary: String?
    let description: String?
    let value: AnyCodable?
    let externalValue: URL?

    init(summary: String? = nil,
         description: String? = nil,
         value: AnyCodable? = nil,
         externalValue: URL? = nil)
    {
        self.summary = summary
        self.description = description
        self.value = value
        self.externalValue = externalValue
    }
}
