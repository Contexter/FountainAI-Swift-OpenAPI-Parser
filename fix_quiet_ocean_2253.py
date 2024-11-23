import os

# Define the base directory
base_dir = "Sources/OpenAPIParserLib"

# Files to update based on the log
files_to_update = {
    "Models/ComponentsObject.swift": {
        "remove_duplicates": True,  # Indicates we need to deduplicate property declarations
        "add_properties": [
            "var schemas: [String: SchemaObject]? // Schema definitions",
            "var responses: [String: ResponseObject]? // Response objects",
            "var parameters: [String: ParameterObject]? // Parameter definitions",
            "var examples: [String: ExampleObject]? // Example definitions",
            "var requestBodies: [String: RequestBodyObject]? // Request body definitions",
            "var headers: [String: HeaderObject]? // Header definitions",
            "var securitySchemes: [String: SecuritySchemeObject]? // Security schemes",
            "var links: [String: LinkObject]? // Link definitions",
            "var callbacks: [String: CallbackObject]? // Callback objects",
        ]
    },
    "Models/OpenAPIPathItemObject.swift": {
        "add_method": """func toDecoder() -> JSONDecoder? {
    let decoder = JSONDecoder()
    // Configure decoder if necessary
    return decoder
}
"""
    },
    "Utilities/ReferenceResolver.swift": {
        "fix_ambiguous_expressions": [
            ("components.schemas?[componentName]", "components.schemas?[componentName] as? SchemaObject as? T"),
            ("components.responses?[componentName]", "components.responses?[componentName] as? ResponseObject as? T"),
            ("components.parameters?[componentName]", "components.parameters?[componentName] as? ParameterObject as? T"),
            ("components.examples?[componentName]", "components.examples?[componentName] as? T"),
            ("components.requestBodies?[componentName]", "components.requestBodies?[componentName] as? T"),
            ("components.headers?[componentName]", "components.headers?[componentName] as? T"),
            ("components.securitySchemes?[componentName]", "components.securitySchemes?[componentName] as? T"),
            ("components.links?[componentName]", "components.links?[componentName] as? T"),
            ("components.callbacks?[componentName]", "components.callbacks?[componentName] as? T"),
        ]
    },
    "Models/OpenAPIDocument.swift": {
        "fix_iteration": [
            ("components.schemas ?? [:]", "(components.schemas as? [String: SchemaObject]) ?? [:]")
        ]
    },
}

# Function to remove duplicate declarations
def remove_duplicates(file_path, properties):
    with open(file_path, "r") as file:
        content = file.readlines()
    
    # Filter out duplicate declarations
    filtered_content = []
    seen_properties = set()
    for line in content:
        stripped_line = line.strip()
        if any(prop.split()[1] in stripped_line for prop in properties):
            if stripped_line in seen_properties:
                continue  # Skip duplicates
            seen_properties.add(stripped_line)
        filtered_content.append(line)

    with open(file_path, "w") as file:
        file.writelines(filtered_content)
    print(f"Removed duplicate declarations in {file_path}")

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

# Function to fix iteration in a file
def fix_iteration(file_path, replacements):
    with open(file_path, "r") as file:
        content = file.read()

    for old, new in replacements:
        content = content.replace(old, new)

    with open(file_path, "w") as file:
        file.write(content)
    print(f"Fixed iteration issues in {file_path}")

# Apply updates to the files
for relative_path, changes in files_to_update.items():
    file_path = os.path.join(base_dir, relative_path)
    
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        continue

    if "remove_duplicates" in changes and changes["remove_duplicates"]:
        remove_duplicates(file_path, changes["add_properties"])
    
    if "add_properties" in changes:
        add_properties(file_path, changes["add_properties"])
    
    if "add_method" in changes:
        add_method(file_path, changes["add_method"])
    
    if "fix_ambiguous_expressions" in changes:
        fix_ambiguous_expressions(file_path, changes["fix_ambiguous_expressions"])
    
    if "fix_iteration" in changes:
        fix_iteration(file_path, changes["fix_iteration"])

print("Fixes applied for quiet-ocean-2253.")

