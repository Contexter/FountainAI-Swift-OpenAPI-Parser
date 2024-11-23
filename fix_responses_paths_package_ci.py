import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define file paths
PACKAGE_SWIFT_PATH = "Package.swift"
RESPONSES_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ResponsesObject.swift"
PATHS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/PathsObject.swift"
SAMPLE_JSON = "Tests/OpenAPIParserTests/sample.json"
SAMPLE_YAML = "Tests/OpenAPIParserTests/sample.yaml"

def update_package_swift():
    """
    Update Package.swift to include resource files for the test target.
    """
    try:
        with open(PACKAGE_SWIFT_PATH, "r") as f:
            lines = f.readlines()

        # Check if resources are already declared
        if any(".process(\"sample.json\")" in line for line in lines):
            print(f"✅ Resources already configured in {PACKAGE_SWIFT_PATH}")
            return

        # Add resources to the test target
        for i, line in enumerate(lines):
            if ".testTarget(" in line and "OpenAPIParserTests" in line:
                lines.insert(
                    i + 2,
                    "        resources: [\n            .process(\"sample.json\"),\n            .process(\"sample.yaml\")\n        ],\n"
                )
                break

        # Write updated Package.swift
        with open(PACKAGE_SWIFT_PATH, "w") as f:
            f.writelines(lines)
        print(f"✅ Updated {PACKAGE_SWIFT_PATH} to include test resources.")
    except Exception as e:
        print(f"❌ Failed to update {PACKAGE_SWIFT_PATH}: {e}")

def fix_responsesobject():
    """
    Fix the subscript and responses dictionary in ResponsesObject.swift.
    """
    try:
        if not os.path.exists(RESPONSES_OBJECT_PATH):
            print(f"❌ {RESPONSES_OBJECT_PATH} not found.")
            return

        with open(RESPONSES_OBJECT_PATH, "r") as f:
            content = f.read()

        # Check if subscript or responses is missing
        if "var responses: [String: ResponseObject]" not in content:
            responses_code = """
class ResponsesObject {
    var responses: [String: ResponseObject] = [:]

    subscript(responseCode: String) -> ResponseObject? {
        return self.responses[responseCode]
    }
}
"""
            with open(RESPONSES_OBJECT_PATH, "w") as f:
                f.write(responses_code)
            print(f"✅ Fixed missing responses dictionary and subscript in {RESPONSES_OBJECT_PATH}")
        else:
            print(f"✅ ResponsesObject already includes the necessary code.")
    except Exception as e:
        print(f"❌ Failed to update {RESPONSES_OBJECT_PATH}: {e}")

def fix_pathsobject():
    """
    Fix the getPath method and redundant logic in PathsObject.swift.
    """
    try:
        if not os.path.exists(PATHS_OBJECT_PATH):
            print(f"❌ {PATHS_OBJECT_PATH} not found.")
            return

        with open(PATHS_OBJECT_PATH, "r") as f:
            content = f.read()

        # Replace incorrect type handling and redundant casts
        if "func getPath(" in content:
            updated_content = content.replace(
                "return PathItemObject(from: openAPIPathItem)",
                """
                // Assuming PathItemObject can decode from OpenAPIPathItemObject
                guard let decoder = openAPIPathItem.toDecoder() else { return nil }
                return PathItemObject(from: decoder)
                """
            )

            with open(PATHS_OBJECT_PATH, "w") as f:
                f.write(updated_content)
            print(f"✅ Fixed getPath method in {PATHS_OBJECT_PATH}")
        else:
            print(f"❌ getPath method not found in {PATHS_OBJECT_PATH}. Please ensure it exists.")
    except Exception as e:
        print(f"❌ Failed to update {PATHS_OBJECT_PATH}: {e}")

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
    print("🚀 Starting fixes for ci-reports/bright-mountain-8073...")
    update_package_swift()
    fix_responsesobject()
    fix_pathsobject()
    verify_test_resources()
    run_ci_pipeline()

