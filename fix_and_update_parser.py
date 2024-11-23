import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define file paths
PACKAGE_SWIFT_PATH = "Package.swift"
PARSER_FILE_PATH = "Sources/OpenAPIParserLib/Parser/OpenAPIParser.swift"
SAMPLE_JSON = "Tests/OpenAPIParserTests/sample.json"
SAMPLE_YAML = "Tests/OpenAPIParserTests/sample.yaml"

def update_package_swift():
    """
    Update Package.swift to include resource files for the test target.
    """
    try:
        with open(PACKAGE_SWIFT_PATH, "r") as f:
            lines = f.readlines()

        # Check if resources are already defined
        if any(".process(\"sample.json\")" in line for line in lines):
            print(f"✅ Resources already configured in {PACKAGE_SWIFT_PATH}")
            return

        # Update test target configuration to include resources
        for i, line in enumerate(lines):
            if ".testTarget(" in line and "OpenAPIParserTests" in line:
                lines.insert(
                    i + 2,
                    "        resources: [\n            .process(\"sample.json\"),\n            .process(\"sample.yaml\")\n        ],\n"
                )
                break

        # Write changes back to Package.swift
        with open(PACKAGE_SWIFT_PATH, "w") as f:
            f.writelines(lines)
        print(f"✅ Updated {PACKAGE_SWIFT_PATH} to include test resources.")
    except Exception as e:
        print(f"❌ Failed to update {PACKAGE_SWIFT_PATH}: {e}")

def update_parser_file():
    """
    Update OpenAPIParser.swift to replace [String: Any] with [String: AnyCodable].
    """
    try:
        with open(PARSER_FILE_PATH, "r") as f:
            content = f.read()

        if "[String: AnyCodable]" in content:
            print(f"✅ {PARSER_FILE_PATH} already uses [String: AnyCodable].")
            return

        # Replace [String: Any] with [String: AnyCodable]
        updated_content = content.replace(
            "[String: Any]",
            "[String: AnyCodable]"
        )

        with open(PARSER_FILE_PATH, "w") as f:
            f.write(updated_content)
        print(f"✅ Updated {PARSER_FILE_PATH} to use [String: AnyCodable].")
    except Exception as e:
        print(f"❌ Failed to update {PARSER_FILE_PATH}: {e}")

def verify_test_files():
    """
    Verify the existence of sample.json and sample.yaml test files.
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
    print("🚀 Starting fix and update process...")
    update_package_swift()
    update_parser_file()
    verify_test_files()
    run_ci_pipeline()

