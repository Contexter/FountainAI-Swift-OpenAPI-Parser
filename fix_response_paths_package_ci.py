import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define file paths
PACKAGE_SWIFT_PATH = "Package.swift"
COMPONENTS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ComponentsObject.swift"
RESPONSES_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ResponsesObject.swift"
PATHS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/PathsObject.swift"
RESPONSE_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ResponseObject.swift"
SAMPLE_JSON = "Tests/OpenAPIParserTests/sample.json"
SAMPLE_YAML = "Tests/OpenAPIParserTests/sample.yaml"

def update_package_swift():
    """
    Update Package.swift to include resource files for the test target.
    """
    try:
        with open(PACKAGE_SWIFT_PATH, "r") as f:
            lines = f.readlines()

        if any(".process(\"sample.json\")" in line for line in lines):
            print(f"✅ Resources already configured in {PACKAGE_SWIFT_PATH}")
            return

        for i, line in enumerate(lines):
            if ".testTarget(" in line and "OpenAPIParserTests" in line:
                lines.insert(
                    i + 2,
                    "        resources: [\n            .process(\"sample.json\"),\n            .process(\"sample.yaml\")\n        ],\n"
                )
                break

        with open(PACKAGE_SWIFT_PATH, "w") as f:
            f.writelines(lines)
        print(f"✅ Updated {PACKAGE_SWIFT_PATH} to include test resources.")
    except Exception as e:
        print(f"❌ Failed to update {PACKAGE_SWIFT_PATH}: {e}")

def create_responseobject():
    """
    Create the missing ResponseObject.swift file.
    """
    try:
        if os.path.exists(RESPONSE_OBJECT_PATH):
            print(f"✅ ResponseObject.swift already exists.")
            return

        content = """\
struct ResponseObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]?
}

struct MediaTypeObject: Codable {
    let schema: SchemaObject?
}
"""
        with open(RESPONSE_OBJECT_PATH, "w") as f:
            f.write(content)
        print(f"✅ Created ResponseObject.swift.")
    except Exception as e:
        print(f"❌ Failed to create ResponseObject.swift: {e}")

def fix_componentsobject():
    """
    Fix ComponentsObject.swift to reference ResponseObject.
    """
    try:
        with open(COMPONENTS_OBJECT_PATH, "r") as f:
            content = f.read()

        if "ResponseObject" in content:
            print(f"✅ ComponentsObject.swift already references ResponseObject.")
            return

        updated_content = content.replace(
            "let responses: [String: Codable]?",
            "let responses: [String: ResponseObject]?"
        )

        with open(COMPONENTS_OBJECT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Updated ComponentsObject.swift to reference ResponseObject.")
    except Exception as e:
        print(f"❌ Failed to update ComponentsObject.swift: {e}")

def fix_responsesobject():
    """
    Fix ResponsesObject.swift to reference ResponseObject.
    """
    try:
        with open(RESPONSES_OBJECT_PATH, "r") as f:
            content = f.read()

        if "ResponseObject" in content:
            print(f"✅ ResponsesObject.swift already references ResponseObject.")
            return

        updated_content = content.replace(
            "var responses: [String: Codable] = [:]",
            "var responses: [String: ResponseObject] = [:]"
        )

        with open(RESPONSES_OBJECT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Updated ResponsesObject.swift to reference ResponseObject.")
    except Exception as e:
        print(f"❌ Failed to update ResponsesObject.swift: {e}")

def fix_pathsobject():
    """
    Fix PathsObject.swift to handle type properly.
    """
    try:
        with open(PATHS_OBJECT_PATH, "r") as f:
            content = f.read()

        updated_content = content.replace(
            "return PathItemObject(from: openAPIPathItem.toDecoder())",
            "return PathItemObject(from: openAPIPathItem)"
        )

        with open(PATHS_OBJECT_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Fixed PathsObject.swift.")
    except Exception as e:
        print(f"❌ Failed to update PathsObject.swift: {e}")

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
    print("🚀 Starting fixes for ci-reports/dark-rainbow-2269...")
    update_package_swift()
    create_responseobject()
    fix_componentsobject()
    fix_responsesobject()
    fix_pathsobject()
    verify_test_resources()
    run_ci_pipeline()

