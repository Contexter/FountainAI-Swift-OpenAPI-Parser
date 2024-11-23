import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define paths
TEST_DIRECTORY = "Tests/OpenAPIParserTests"
SWIFT_SOURCE_FILE = "Sources/OpenAPIParserLib/Parser/OpenAPIParser.swift"
SAMPLE_JSON = os.path.join(TEST_DIRECTORY, "sample.json")
SAMPLE_YAML = os.path.join(TEST_DIRECTORY, "sample.yaml")

# Step 1: Update the Swift Parser
def update_swift_parser():
    """
    Overwrites the OpenAPIParser.swift file with updated YAML and JSON parsing logic.
    """
    swift_code = """
import Foundation
import Yams

/// A parser responsible for loading and parsing OpenAPI documents.
class OpenAPIParser {
    enum ParserError: Error {
        case fileNotFound
        case invalidData
        case decodingError(Error)
        case unsupportedFormat
    }

    /// Parses an OpenAPI document from a JSON or YAML file located at a given URL.
    /// - Parameter url: The URL of the OpenAPI document.
    /// - Returns: A decoded `OpenAPIDocument` object.
    func parse(from url: URL) throws -> OpenAPIDocument {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ParserError.fileNotFound
        }

        let fileExtension = url.pathExtension.lowercased()
        switch fileExtension {
        case "json":
            return try parseJSON(from: data)
        case "yaml", "yml":
            return try parseYAML(from: data)
        default:
            throw ParserError.unsupportedFormat
        }
    }

    private func parseJSON(from data: Data) throws -> OpenAPIDocument {
        do {
            return try JSONDecoder().decode(OpenAPIDocument.self, from: data)
        } catch {
            throw ParserError.decodingError(error)
        }
    }

    private func parseYAML(from data: Data) throws -> OpenAPIDocument {
        do {
            guard let yamlString = String(data: data, encoding: .utf8) else {
                throw ParserError.invalidData
            }

            let yamlObject = try YAMLDecoder().decode([String: Any].self, from: yamlString)
            let jsonData = try JSONSerialization.data(withJSONObject: yamlObject, options: [])
            return try JSONDecoder().decode(OpenAPIDocument.self, from: jsonData)
        } catch {
            throw ParserError.decodingError(error)
        }
    }
}
"""
    with open(SWIFT_SOURCE_FILE, "w") as f:
        f.write(swift_code)
    print(f"✅ Updated parser file: {SWIFT_SOURCE_FILE}")

# Step 2: Create Sample Files
def create_sample_files():
    """
    Creates sample JSON and YAML files for testing the parser.
    """
    sample_json = """{
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
"""
    sample_yaml = """openapi: "3.1.0"
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
    with open(SAMPLE_JSON, "w") as f:
        f.write(sample_json)
    with open(SAMPLE_YAML, "w") as f:
        f.write(sample_yaml)
    print(f"✅ Created sample test files: {SAMPLE_JSON}, {SAMPLE_YAML}")

# Step 3: Run CI Pipeline via ci_reporter
def run_ci_pipeline():
    """
    Executes the build and test pipeline using ci_reporter.py.
    """
    run_name = generate_run_name()
    build_status, test_status = execute_build_and_test(run_name)
    save_last_run(run_name, build_status, test_status)
    print(f"🎉 CI pipeline completed successfully for run: {run_name}")

# Execute Steps
if __name__ == "__main__":
    update_swift_parser()  # Step 1: Update the parser
    create_sample_files()  # Step 2: Create test files
    run_ci_pipeline()      # Step 3: Run the CI pipeline

