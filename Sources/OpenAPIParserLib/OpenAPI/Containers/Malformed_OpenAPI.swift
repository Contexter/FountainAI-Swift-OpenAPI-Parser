struct Malformed_OpenAPI {
    // YAML with the `paths` key entirely missing
    static let yamlMissingPaths = """
    openapi: "3.1.0"
    info:
      title: "Invalid API"
      version: "1.0.0"
    """

    // YAML with an empty `paths` object
    static let yamlEmptyPaths = """
    openapi: "3.1.0"
    info:
      title: "Invalid API"
      version: "1.0.0"
    paths: {}
    """
}
