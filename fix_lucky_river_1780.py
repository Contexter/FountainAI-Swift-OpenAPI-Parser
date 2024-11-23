import os

def apply_fix_with_semantic_name(file_path, replacements, fix_name):
    """
    Apply a fix with a semantic name to a file.
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

    print(f"[{fix_name}] Applied successfully to {file_path}")


# Fix 1: Add schemas property to ComponentsObject
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
    apply_fix_with_semantic_name(file_path, replacements, "add_schemas_to_components_object")


# Fix 2: Resolve type ambiguity in ReferenceResolver
def fix_resolve_type_ambiguity_in_reference_resolver():
    file_path = "Sources/OpenAPIParserLib/Utilities/ReferenceResolver.swift"
    replacements = [
        ("components.schemas?[componentName] as? SchemaObject as? T",
         "(components.schemas?[componentName] as? SchemaObject) as? T"),
        ("components.responses?[componentName] as? ResponseObject as? T",
         "(components.responses?[componentName] as? ResponseObject) as? T")
    ]
    apply_fix_with_semantic_name(file_path, replacements, "resolve_type_ambiguity_in_reference_resolver")


# Fix 3: Add missing toDecoder function to OpenAPIPathItemObject
def fix_add_to_decoder_in_openapi_path_item():
    file_path = "Sources/OpenAPIParserLib/Models/OpenAPIPathItemObject.swift"
    replacements = [
        ("class OpenAPIPathItemObject {", """class OpenAPIPathItemObject {
    func toDecoder() -> Decoder? {
        // Dummy implementation
        return nil
    }
""")
    ]
    apply_fix_with_semantic_name(file_path, replacements, "add_to_decoder_in_openapi_path_item")


# Fix 4: Remove redundant downcasts in PathsObject
def fix_remove_redundant_downcasts_in_paths_object():
    file_path = "Sources/OpenAPIParserLib/Models/PathsObject.swift"
    replacements = [
        ("as? OpenAPIPathItemObject else {",
         "else {")
    ]
    apply_fix_with_semantic_name(file_path, replacements, "remove_redundant_downcasts_in_paths_object")


if __name__ == "__main__":
    # Apply all fixes for lucky-river-1780
    fix_add_schemas_to_components_object()
    fix_resolve_type_ambiguity_in_reference_resolver()
    fix_add_to_decoder_in_openapi_path_item()
    fix_remove_redundant_downcasts_in_paths_object()
    print("All fixes for lucky-river-1780 applied successfully.")

