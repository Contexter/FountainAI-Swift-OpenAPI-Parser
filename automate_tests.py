import os
import subprocess
import sys
import shutil

def create_test_resources():
    """
    Create the required TestResources directory and add example OpenAPI specs if they don't already exist.
    """
    test_resources_dir = os.path.join("Tests", "TestResources")
    os.makedirs(test_resources_dir, exist_ok=True)
    
    example_specs = {
        "Central-Sequence-Service.yml": """openapi: 3.1.0
info:
  title: Central Sequence Service
  version: "1.0.0"
paths:
  /sequences:
    get:
      summary: Get all sequences
      responses:
        '200':
          description: A list of sequences
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Sequence'
components:
  schemas:
    Sequence:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        steps:
          type: integer
""",
        "Character-Service.yml": """openapi: 3.1.0
info:
  title: Character Service
  version: "1.0.0"
paths:
  /characters:
    get:
      summary: Get all characters
      responses:
        '200':
          description: A list of characters
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Character'
components:
  schemas:
    Character:
      type: object
      properties:
        id:
          type: string
        name:
          type: string
        description:
          type: string
"""
    }

    for filename, content in example_specs.items():
        file_path = os.path.join(test_resources_dir, filename)
        if not os.path.exists(file_path):
            with open(file_path, "w") as f:
                f.write(content.strip())
                print(f"✅ Created test spec: {file_path}")
        else:
            print(f"⚠️ Spec already exists: {file_path}")


def create_tests_file():
    """
    Create OpenAPIParserTests.swift with detailed tests.
    """
    tests_dir = os.path.join("Tests", "OpenAPIParserTests")
    os.makedirs(tests_dir, exist_ok=True)

    test_file_path = os.path.join(tests_dir, "OpenAPIParserTests.swift")
    if not os.path.exists(test_file_path):
        with open(test_file_path, "w") as f:
            f.write(
                """import XCTest
@testable import OpenAPIParserLib

final class OpenAPIParserTests: XCTestCase {

    func loadSpec(named name: String) -> Data {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: name, withExtension: "yml") else {
            fatalError("Specification \\(name) not found in TestResources")
        }
        return try! Data(contentsOf: url)
    }

    func testBasicParsing() throws {
        let specData = loadSpec(named: "Central-Sequence-Service")
        let parser = OpenAPIParser()
        let document = try parser.parse(data: specData)

        XCTAssertEqual(document.openapi, "3.1.0")
        XCTAssertNotNil(document.info)
        XCTAssertFalse(document.paths.isEmpty)
    }

    func testParseMultipleSpecs() throws {
        let specs = ["Central-Sequence-Service", "Character-Service"]
        for specName in specs {
            let specData = loadSpec(named: specName)
            let parser = OpenAPIParser()
            let document = try parser.parse(data: specData)

            XCTAssertEqual(document.openapi, "3.1.0")
            XCTAssertNotNil(document.info)
            XCTAssertFalse(document.paths.isEmpty)
        }
    }

    func testInvalidSpec() {
        let invalidSpec = \"\"\"
        openapi: 3.0.0
        info: {}
        \"\"\"
        let parser = OpenAPIParser()

        XCTAssertThrowsError(try parser.parse(data: invalidSpec.data(using: .utf8)!)) { error in
            XCTAssertTrue(error is OpenAPIParserError)
        }
    }
}
"""
            )
            print(f"✅ Created test file: {test_file_path}")
    else:
        print(f"⚠️ Test file already exists: {test_file_path}")


def run_tests():
    """
    Run Swift tests and ensure coverage.
    """
    print("Running tests...")
    result = subprocess.run(["swift", "test", "--enable-code-coverage"], text=True)
    print(result.stdout)
    print(result.stderr)

    if result.returncode != 0:
        print("❌ Tests failed.")
        sys.exit(result.returncode)
    print("✅ All tests passed.")


def generate_coverage_report():
    """
    Generate and display the code coverage report.
    """
    print("Generating code coverage report...")
    result = subprocess.run(["swift", "package", "generate-xcodeproj"], text=True)
    if result.returncode == 0:
        print("✅ Code coverage project generated.")
    else:
        print("⚠️ Failed to generate Xcode project for coverage.")


def clean_build():
    """
    Clean the build artifacts.
    """
    print("Cleaning build artifacts...")
    subprocess.run(["swift", "package", "clean"])
    print("✅ Cleaned.")


def format_code():
    """
    Format code using swift-format.
    """
    print("Formatting code...")
    result = subprocess.run(["swift-format", "lint", "-r", "."], text=True)
    print(result.stdout)
    print(result.stderr)
    print("✅ Code formatted.")


def main():
    """
    Main entry point for the script.
    """
    create_test_resources()
    create_tests_file()
    clean_build()
    format_code()
    run_tests()
    generate_coverage_report()


if __name__ == "__main__":
    main()
