import Foundation

/// Represents a container for reusable objects in an OpenAPI document.
struct ComponentsObject: Codable {
    let schemas: [String: SchemaObject]?
    let responses: [String: ResponseObject]?
    let parameters: [String: ParameterObject]?
    let examples: [String: ExampleObject]?
    let requestBodies: [String: RequestBodyObject]?
    let headers: [String: HeaderObject]?
    let securitySchemes: [String: SecuritySchemeObject]?
    let links: [String: LinkObject]?
    let callbacks: [String: CallbackObject]?

    init(schemas: [String: SchemaObject]? = nil,
         responses: [String: ResponseObject]? = nil,
         parameters: [String: ParameterObject]? = nil,
         examples: [String: ExampleObject]? = nil,
         requestBodies: [String: RequestBodyObject]? = nil,
         headers: [String: HeaderObject]? = nil,
         securitySchemes: [String: SecuritySchemeObject]? = nil,
         links: [String: LinkObject]? = nil,
         callbacks: [String: CallbackObject]? = nil)
    {
        self.schemas = schemas
        self.responses = responses
        self.parameters = parameters
        self.examples = examples
        self.requestBodies = requestBodies
        self.headers = headers
        self.securitySchemes = securitySchemes
        self.links = links
        self.callbacks = callbacks
    }
}
