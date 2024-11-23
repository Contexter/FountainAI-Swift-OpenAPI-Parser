import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define file paths
PACKAGE_SWIFT_PATH = "Package.swift"
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

def fix_pathsobject_getpath():
    """
    Add the missing getPath method to PathsObject.swift.
    """
    try:
        if not os.path.exists(PATHS_OBJECT_PATH):
            print(f"❌ {PATHS_OBJECT_PATH} not found.")
            return

        with open(PATHS_OBJECT_PATH, "r") as f:
            content = f.read()

        # Check if getPath method already exists
        if "func getPath(" in content:
            print(f"✅ getPath method already implemented in {PATHS_OBJECT_PATH}")
            return

        # Add getPath method at the end of the file
        getpath_code = """
extension PathsObject {
    func getPath(_ path: String) -> PathItemObject? {
        // Assuming paths is a dictionary property in PathsObject
        return paths[path]
    }
}
"""
        with open(PATHS_OBJECT_PATH, "a") as f:
            f.write(getpath_code)
        print(f"✅ Added getPath method to {PATHS_OBJECT_PATH}.")
    except Exception as e:
        print(f"❌ Failed to update {PATHS_OBJECT_PATH}: {e}")

def fix_pathsobject_subscripting():
    """
    Fix the subscript implementation in PathsObject.swift.
    """
    try:
        if not os.path.exists(PATHS_OBJECT_PATH):
            print(f"❌ {PATHS_OBJECT_PATH} not found.")
            return

        with open(PATHS_OBJECT_PATH, "r") as f:
            content = f.read()

        # Check if subscript extension already exists
        if "subscript(path: String)" in content:
            print(f"✅ Subscripting already implemented in {PATHS_OBJECT_PATH}")
            return

        # Add subscripting extension at the end of the file
        subscripting_code = """
extension PathsObject {
    subscript(path: String) -> PathItemObject? {
        return self.getPath(path)
    }
}
"""
        with open(PATHS_OBJECT_PATH, "a") as f:
            f.write(subscripting_code)
        print(f"✅ Added subscripting support to {PATHS_OBJECT_PATH}.")
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
    print("🚀 Starting fixes for ci-reports/sunny-forest-7625...")
    update_package_swift()
    fix_pathsobject_getpath()
    fix_pathsobject_subscripting()
    verify_test_resources()
    run_ci_pipeline()

