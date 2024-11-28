import Foundation

struct Malformed_OpenAPI {
    static let yamlMissingPaths = """
    openapi: "3.1.0"
    info:
      title: "Invalid API"
      version: "1.0.0"
    """

    static let yamlInvalidStructure = """
    openapi: "3.1.0"
    info:
      title: "Malformed API"
      version: "1.0.0"
    paths: "This should be an object, not a string."
    """
}
