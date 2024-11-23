import os

# Define the base directory
base_dir = "Sources/OpenAPIParserLib"

# Files to update based on the log
files_to_update = {
    "Models/ComponentsObject.swift": {
        "add_properties": [
            "var schemas: [String: SchemaObject]? // Added schemas property",
            "var responses: [String: ResponseObject]? // Added responses property",
            "var parameters: [String: ParameterObject]? // Added parameters property",
            "var examples: [String: ExampleObject]? // Added examples property",
            "var requestBodies: [String: RequestBodyObject]? // Added requestBodies property",
            "var headers: [String: HeaderObject]? // Added headers property",
            "var securitySchemes: [String: SecuritySchemeObject]? // Added securitySchemes property",
            "var links: [String: LinkObject]? // Added links property",
            "var callbacks: [String: CallbackObject]? // Added callbacks property",
        ]
    },
    "Models/OpenAPIPathItemObject.swift": {
        "add_method": """func toDecoder() -> JSONDecoder? {
    let decoder = JSONDecoder()
    // Configure decoder if needed
    return decoder
}
"""
    },
    "Utilities/ReferenceResolver.swift": {
        "fix_ambiguous_expressions": [
            ("components.schemas?[componentName] as? SchemaObject", "components.schemas?[componentName] as? SchemaObject as? T"),
            ("components.responses?[componentName] as? ResponseObject", "components.responses?[componentName] as? ResponseObject as? T"),
            ("components.parameters?[componentName] as? ParameterObject", "components.parameters?[componentName] as? ParameterObject as? T"),
            ("components.examples?[componentName]", "components.examples?[componentName] as? T"),
            ("components.requestBodies?[componentName]", "components.requestBodies?[componentName] as? T"),
            ("components.headers?[componentName]", "components.headers?[componentName] as? T"),
            ("components.securitySchemes?[componentName]", "components.securitySchemes?[componentName] as? T"),
            ("components.links?[componentName]", "components.links?[componentName] as? T"),
            ("components.callbacks?[componentName]", "components.callbacks?[componentName] as? T"),
        ]
    },
}

# Function to add properties to a file
def add_properties(file_path, properties):
    with open(file_path, "a") as file:
        file.write("\n// Auto-generated properties\n")
        for prop in properties:
            file.write(f"{prop}\n")
    print(f"Added properties to {file_path}")

# Function to add a method to a file
def add_method(file_path, method):
    with open(file_path, "a") as file:
        file.write("\n// Auto-generated method\n")
        file.write(f"{method}\n")
    print(f"Added method to {file_path}")

# Function to fix ambiguous expressions in a file
def fix_ambiguous_expressions(file_path, replacements):
    with open(file_path, "r") as file:
        content = file.read()
    
    for old, new in replacements:
        content = content.replace(old, new)
    
    with open(file_path, "w") as file:
        file.write(content)
    print(f"Fixed ambiguous expressions in {file_path}")

# Apply updates to the files
for relative_path, changes in files_to_update.items():
    file_path = os.path.join(base_dir, relative_path)
    
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue
    
    if "add_properties" in changes:
        add_properties(file_path, changes["add_properties"])
    
    if "add_method" in changes:
        add_method(file_path, changes["add_method"])
    
    if "fix_ambiguous_expressions" in changes:
        fix_ambiguous_expressions(file_path, changes["fix_ambiguous_expressions"])

print("Fixes applied for quiet-mountain-9017.")
