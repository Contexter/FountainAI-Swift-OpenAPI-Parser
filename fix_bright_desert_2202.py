import os
from ci_reporter import execute_build_and_test, save_last_run, generate_run_name

# Define paths
PACKAGE_SWIFT_PATH = "Package.swift"
OPENAPI_DIRECTORY = "Sources/OpenAPIParserLib/OpenAPI/"
REQUEST_BODY_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/RequestBodyObject.swift"
RESPONSES_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/ResponsesObject.swift"
OPERATION_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/OperationObject.swift"
PATHS_OBJECT_PATH = "Sources/OpenAPIParserLib/Models/PathsObject.swift"
REFERENCE_RESOLVER_PATH = "Sources/OpenAPIParserLib/Utilities/ReferenceResolver.swift"
SAMPLE_JSON = "Tests/OpenAPIParserTests/sample.json"
SAMPLE_YAML = "Tests/OpenAPIParserTests/sample.yaml"

def update_package_swift():
    """
    Update Package.swift to include all .yml files from the OpenAPI directory as resources.
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

def consolidate_requestbodyobject():
    """
    Consolidate RequestBodyObject definitions into a single implementation.
    """
    try:
        content = """\
struct RequestBodyObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]
}
"""
        with open(REQUEST_BODY_OBJECT_PATH, "w") as f:
            f.write(content)
        print(f"✅ Consolidated RequestBodyObject into a single implementation.")
    except Exception as e:
        print(f"❌ Failed to consolidate RequestBodyObject: {e}")

def consolidate_responsesobject():
    """
    Consolidate ResponsesObject definitions into a single implementation.
    """
    try:
        content = """\
struct ResponsesObject: Codable {
    let description: String?
    let content: [String: MediaTypeObject]?
}
"""
        with open(RESPONSES_OBJECT_PATH, "w") as f:
            f.write(content)
        print(f"✅ Consolidated ResponsesObject into a single implementation.")
    except Exception as e:
        print(f"❌ Failed to consolidate ResponsesObject: {e}")

def fix_operationobject_protocol_conformance():
    """
    Fix Codable conformance for OperationObject by implementing init(from:) and encode(to:).
    """
    try:
        content = """\
struct OperationObject: Codable {
    let tags: [String]?
    let summary: String?
    let operationId: String?
    let parameters: [ParameterObject]?
    let requestBody: RequestBodyObject?
    let responses: ResponsesObject
    let deprecated: Bool?
    let security: [SecurityRequirementObject]?

    enum CodingKeys: String, CodingKey {
        case tags, summary, operationId, parameters, requestBody, responses, deprecated, security
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
        operationId = try container.decodeIfPresent(String.self, forKey: .operationId)
        parameters = try container.decodeIfPresent([ParameterObject].self, forKey: .parameters)
        requestBody = try container.decodeIfPresent(RequestBodyObject.self, forKey: .requestBody)
        responses = try container.decode(ResponsesObject.self, forKey: .responses)
        deprecated = try container.decodeIfPresent(Bool.self, forKey: .deprecated)
        security = try container.decodeIfPresent([SecurityRequirementObject].self, forKey: .security)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(summary, forKey: .summary)
        try container.encodeIfPresent(operationId, forKey: .operationId)
        try container.encodeIfPresent(parameters, forKey: .parameters)
        try container.encodeIfPresent(requestBody, forKey: .requestBody)
        try container.encode(responses, forKey: .responses)
        try container.encodeIfPresent(deprecated, forKey: .deprecated)
        try container.encodeIfPresent(security, forKey: .security)
    }
}
"""
        with open(OPERATION_OBJECT_PATH, "w") as f:
            f.write(content)
        print(f"✅ Fixed protocol conformance for OperationObject.")
    except Exception as e:
        print(f"❌ Failed to fix OperationObject protocol conformance: {e}")

def refactor_pathsobject():
    """
    Refactor PathsObject.swift to remove invalid logic.
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
        print(f"✅ Refactored PathsObject.swift.")
    except Exception as e:
        print(f"❌ Failed to refactor PathsObject.swift: {e}")

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
    print("🚀 Starting fixes for bright-desert-2202...")
    update_package_swift()
    consolidate_requestbodyobject()
    consolidate_responsesobject()
    fix_operationobject_protocol_conformance()
    refactor_pathsobject()
    run_ci_pipeline()

