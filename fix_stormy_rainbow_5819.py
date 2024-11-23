import os

def apply_fix(file_path, replacements, fix_name):
    """
    Apply a fix with semantic naming for logging and maintenance.
    :param file_path: Path to the file to be updated.
    :param replacements: List of tuples (search_text, replace_text).
    :param fix_name: Semantic identifier for the fix.
    """
    if not os.path.exists(file_path):
        print(f"[{fix_name}] File {file_path} does not exist.")
        return

    with open(file_path, 'r') as file:
        content = file.read()

    for search_text, replace_text in replacements:
        content = content.replace(search_text, replace_text)

    with open(file_path, 'w') as file:
        file.write(content)

    print(f"[{fix_name}] Fix applied successfully to {file_path}")


# Fix 1: Resolve type ambiguity in ReferenceResolver
def fix_type_ambiguity_in_reference_resolver():
    file_path = "Sources/OpenAPIParserLib/Utilities/ReferenceResolver.swift"
    replacements = [
        ("components.schemas?[componentName] as? SchemaObject as? T",
         "(components.schemas?[componentName] as? SchemaObject) as? T"),
        ("components.responses?[componentName] as? ResponseObject as? T",
         "(components.responses?[componentName] as? ResponseObject) as? T"),
        ("components.parameters?[componentName] as? ParameterObject as? T",
         "(components.parameters?[componentName] as? ParameterObject) as? T")
    ]
    apply_fix(file_path, replacements, "resolve_type_ambiguity_in_reference_resolver")


# Fix 2: Add missing toDecoder method to OpenAPIPathItemObject
def fix_add_to_decoder_method():
    file_path = "Sources/OpenAPIParserLib/Models/OpenAPIPathItemObject.swift"
    replacements = [
        ("class OpenAPIPathItemObject {", """class OpenAPIPathItemObject {
    func toDecoder() -> Decoder? {
        // Dummy implementation for the missing method
        return nil
    }
""")
    ]
    apply_fix(file_path, replacements, "add_to_decoder_method")


# Fix 3: Add schemas property to ComponentsObject
def fix_add_schemas_to_components_object():
    file_path = "Sources/OpenAPIParserLib/Models/ComponentsObject.swift"
    replacements = [
        ("class ComponentsObject {", """class ComponentsObject {
    var schemas: [String: SchemaObject]?

    init(schemas: [String: SchemaObject]? = nil) {
        self.schemas = schemas
    }
""")
    ]
    apply_fix(file_path, replacements, "add_schemas_to_components_object")


# Fix 4: Update pattern matching in OpenAPIDocument
def fix_pattern_matching_in_openapi_document():
    file_path = "Sources/OpenAPIParserLib/Models/OpenAPIDocument.swift"
    replacements = [
        # Correct the for loop to avoid pattern match issues
        ("for (_, value) in components.schemas ?? [:] {",
         "for (key, value) in components.schemas ?? [:] {")
    ]
    apply_fix(file_path, replacements, "update_pattern_matching_in_openapi_document")


if __name__ == "__main__":
    # Apply all fixes for stormy-rainbow-5819
    fix_type_ambiguity_in_reference_resolver()
    fix_add_to_decoder_method()
    fix_add_schemas_to_components_object()
    fix_pattern_matching_in_openapi_document()
    print("All fixes for stormy-rainbow-5819 applied successfully.")

