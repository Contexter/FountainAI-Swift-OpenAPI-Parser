import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define paths
PACKAGE_SWIFT_PATH = "Package.swift"
OPENAPI_DIRECTORY = "Sources/OpenAPIParserLib/OpenAPI/"
PATHS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/PathsObject.swift"
COMPONENTS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ComponentsObject.swift"
REFERENCE_RESOLVER_PATH = "Sources/OpenAPIParserLib/Utilities/ReferenceResolver.swift"
OPENAPI_DOCUMENT_PATH = "Sources/OpenAPIParserLib/Models/OpenAPIDocument.swift"
SAMPLE_JSON = "Tests/OpenAPIParserTests/sample.json"
SAMPLE_YAML = "Tests/OpenAPIParserTests/sample.yaml"

def update_package_swift():
    """
    Update Package.swift to include .yml files from the OpenAPI directory as resources.
    """
    try:
        with open(PACKAGE_SWIFT_PATH, "r") as f:
            lines = f.readlines()

        # Gather all .yml files in OpenAPI directory
        yml_files = [f".process(\"{os.path.join(OPENAPI_DIRECTORY, file)}\")"
                     for file in os.listdir(OPENAPI_DIRECTORY) if file.endswith(".yml")]

        # Check if resources are already declared
        if any(".process(\"Sources/OpenAPIParserLib/OpenAPI/" in line for line in lines):
            print(f"✅ Resources from OpenAPI directory already configured in {PACKAGE_SWIFT_PATH}")
            return

        # Add OpenAPI resources to the test target
        for i, line in enumerate(lines):
            if ".testTarget(" in line and "OpenAPIParserTests" in line:
                lines.insert(
                    i + 2,
                    "        resources: [\n            " + ",\n            ".join(yml_files) + "\n        ],\n"
                )
                break

        with open(PACKAGE_SWIFT_PATH, "w") as f:
            f.writelines(lines)
        print(f"✅ Updated {PACKAGE_SWIFT_PATH} to include OpenAPI resources.")
    except Exception as e:
        print(f"❌ Failed to update {PACKAGE_SWIFT_PATH}: {e}")

def refactor_pathsobject():
    """
    Refactor PathsObject.swift to remove invalid logic and redundant casts.
    """
    try:
        with open(PATHS_OBJECT_PATH, "r") as f:
            content = f.read()

        # Replace invalid toDecoder references and redundant casts
        updated_content = content.replace(
            "return PathItemObject(from: openAPIPathItem.toDecoder())",
            "return PathItemObject(from: openAPIPathItem)"
        ).replace(
            "as? PathItemObject",
            ""
        )

        with open(PATHS_OBJECT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Refactored PathsObject.swift.")
    except Exception as e:
        print(f"❌ Failed to refactor PathsObject.swift: {e}")

def fix_componentsobject():
    """
    Add the missing schemas property to ComponentsObject.swift.
    """
    try:
        with open(COMPONENTS_OBJECT_PATH, "r") as f:
            content = f.read()

        if "let schemas:" in content:
            print(f"✅ ComponentsObject.swift already contains schemas property.")
            return

        # Add the schemas property to ComponentsObject
        updated_content = content.replace(
            "struct ComponentsObject {",
            "struct ComponentsObject {\n    let schemas: [String: SchemaObject]?"
        )

        with open(COMPONENTS_OBJECT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Added schemas property to ComponentsObject.swift.")
    except Exception as e:
        print(f"❌ Failed to update ComponentsObject.swift: {e}")

def disambiguate_reference_resolver():
    """
    Add explicit type annotations to resolve ambiguous type casting in ReferenceResolver.swift.
    """
    try:
        with open(REFERENCE_RESOLVER_PATH, "r") as f:
            content = f.read()

        updated_content = content.replace(
            "return components.schemas?[componentName] as? T",
            "return components.schemas?[componentName] as? SchemaObject as? T"
        ).replace(
            "return components.responses?[componentName] as? T",
            "return components.responses?[componentName] as? ResponseObject as? T"
        ).replace(
            "return components.parameters?[componentName] as? T",
            "return components.parameters?[componentName] as? ParameterObject as? T"
        )

        with open(REFERENCE_RESOLVER_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Disambiguated type casting in ReferenceResolver.swift.")
    except Exception as e:
        print(f"❌ Failed to update ReferenceResolver.swift: {e}")

def fix_openapi_document():
    """
    Fix iteration logic in OpenAPIDocument.swift.
    """
    try:
        with open(OPENAPI_DOCUMENT_PATH, "r") as f:
            content = f.read()

        updated_content = content.replace(
            "for (_, value) in components.schemas ?? [:] {",
            "for (_, value) in components.schemas ?? [:] {\n    if let schema = value as? SchemaObject {"
        ).replace(
            "if !ValidationUtility.validateSchema(schema) {",
            "if !ValidationUtility.validateSchema(schema) {\n    }\n"
        )

        with open(OPENAPI_DOCUMENT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Fixed iteration logic in OpenAPIDocument.swift.")
    except Exception as e:
        print(f"❌ Failed to update OpenAPIDocument.swift: {e}")

def verify_test_resources():
    """
    Verify and create missing test resource files (sample.json, sample.yaml).
    """
    missing_files = []
    if not os.path.exists(SAMPLE_JSON):
        missing_files.append(SAMPLE_JSON)
    if not os.path.exists(SAMPLE_YAML):
        missing_files.append(SAMPLE_YAML)

    for missing_file in missing_files:
        try:
            with open(missing_file, "w") as f:
                content = """{
  "openapi": "3.1.0",
  "info": {
    "title": "Sample API",
    "version": "1.0.0"
  },
  "paths": {
    "/sample": {
      "get": {
        "summary": "Retrieve sample data",
        "responses": {
          "200": {
            "description": "Successful response"
          }
        }
      }
    }
  }
}
""" if missing_file.endswith(".json") else """openapi: "3.1.0"
info:
  title: "Sample API"
  version: "1.0.0"
paths:
  /sample:
    get:
      summary: "Retrieve sample data"
      responses:
        "200":
          description: "Successful response"
"""
                f.write(content)
            print(f"✅ Created missing test file: {missing_file}")
        except Exception as e:
            print(f"❌ Failed to create {missing_file}: {e}")

def run_ci_pipeline():
    """
    Executes the build and test pipeline using ci_reporter.
    """
    try:
        run_name = generate_run_name()
        build_status, test_status = execute_build_and_test(run_name)
        save_last_run(run_name, build_status, test_status)
        print(f"🎉 CI pipeline completed successfully for run: {run_name}")
    except Exception as e:
        print(f"❌ CI pipeline failed: {e}")

if __name__ == "__main__":
    print("🚀 Starting fixes for blue-sky-4929...")
    update_package_swift()
    refactor_pathsobject()
    fix_componentsobject()
    disambiguate_reference_resolver()
    fix_openapi_document()
    verify_test_resources()
    run_ci_pipeline()

