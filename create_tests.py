import os

# Base test directory where the test files will be created
base_test_directory = "Tests/OpenAPIParserTests/"

# List of OpenAPI specs and their corresponding test details
tests = [
    ("Test_ActionService.swift", "Sources/OpenAPIParserLib/OpenAPI/Action-Service.yml", "Action Service", "ActionObject", ["/actions", "id", "description"]),
    ("Test_CentralSequenceService.swift", "Sources/OpenAPIParserLib/OpenAPI/Central-Sequence-Service.yml", "Central Sequence Service", "SequenceObject", ["/sequences", "id", "actions"]),
    ("Test_CharacterService.swift", "Sources/OpenAPIParserLib/OpenAPI/Character-Service.yml", "Character Service", "CharacterObject", ["/characters", "id", "name", "description"]),
    ("Test_CoreScriptManagementService.swift", "Sources/OpenAPIParserLib/OpenAPI/Core-Script-Managment-Service.yml", "Core Script Management Service", "ScriptObject", ["/scripts", "id", "title", "content"]),
    ("Test_EnsembleService.swift", "Sources/OpenAPIParserLib/OpenAPI/Ensemble-Service.yml", "Ensemble Service", "EnsembleObject", ["/ensembles", "id", "members"]),
    ("Test_ParaphraseService.swift", "Sources/OpenAPIParserLib/OpenAPI/Paraphrase-Service.yml", "Paraphrase Service", "ParaphraseObject", ["/paraphrases", "id", "text", "commentary"]),
    ("Test_PerformerService.swift", "Sources/OpenAPIParserLib/OpenAPI/Performer-Service.yml", "Performer Service", "PerformerObject", ["/performers", "id", "name", "role"]),
    ("Test_SessionAndContextService.swift", "Sources/OpenAPIParserLib/OpenAPI/Session-And-Context-Service.yml", "Session And Context Service", "SessionObject", ["/sessions", "/contexts", "id", "context"]),
    ("Test_SpokenWordService.swift", "Sources/OpenAPIParserLib/OpenAPI/Spoken-Word-Service.yml", "Spoken Word Service", "SpokenWordObject", ["/spoken-words", "id", "text", "sequence"]),
    ("Test_StoryFactoryService.swift", "Sources/OpenAPIParserLib/OpenAPI/Story-Factory-Service.yml", "Story Factory Service", "StoryObject", ["/stories", "id", "title", "content"]),
]

# Template for the test file content
test_template = """import XCTest
@testable import OpenAPIParserLib

final class {class_name}: XCTestCase {{

    func testParse{class_base_name}Spec() {{
        // Load the OpenAPI specification file
        let filePath = "{spec_path}"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {{
            XCTFail("Failed to load {spec_name}")
            return
        }}
        
        // Parse the file
        do {{
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Assert the document structure
            XCTAssertNotNil(document.info, "Info object is missing.")
            XCTAssertEqual(document.info.title, "{service_name}", "Title mismatch.")
            XCTAssertEqual(document.info.version, "1.0.0", "Version mismatch.")
            
            // Validate paths
            XCTAssertNotNil(document.paths, "Paths object is missing.")
            {path_checks}
            
            // Validate schemas
            XCTAssertNotNil(document.components?.schemas, "Schemas object is missing.")
            XCTAssertTrue(document.components?.schemas.keys.contains("{schema_name}") ?? false, "Missing '{schema_name}' schema.")
            
        }} catch {{
            XCTFail("Parsing failed with error: \\(error)")
        }}
    }}

    func test{schema_base_name}Schema() {{
        // Load and parse the spec
        let filePath = "{spec_path}"
        guard let specData = try? String(contentsOfFile: filePath, encoding: .utf8) else {{
            XCTFail("Failed to load {spec_name}")
            return
        }}
        
        do {{
            let parser = OpenAPIParser()
            let document = try parser.parse(from: specData)
            
            // Validate specific schema details
            guard let schema = document.components?.schemas["{schema_name}"] else {{
                XCTFail("{schema_name} schema is missing.")
                return
            }}
            
            XCTAssertEqual(schema.type, "object", "{schema_name} schema should be of type 'object'.")
            {property_checks}
        }} catch {{
            XCTFail("Parsing failed with error: \\(error)")
        }}
    }}
}}
"""

# Create the test files
for test_file, spec_path, service_name, schema_name, details in tests:
    class_name = test_file.replace(".swift", "")
    class_base_name = schema_name.replace("Object", "")
    spec_name = os.path.basename(spec_path)
    expected_paths = [detail for detail in details if detail.startswith("/")]
    properties = [detail for detail in details if not detail.startswith("/")]

    # Generate path checks
    path_checks = "\n            ".join([f'XCTAssertTrue(document.paths.contains("{path}"), "Missing \'{path}\' endpoint.")' for path in expected_paths])

    # Generate property checks
    property_checks = "\n            ".join(
        [f'XCTAssertTrue(schema.properties?.keys.contains("{prop}") ?? false, "{schema_name} schema is missing \'{prop}\' property.")'
         for prop in properties])

    # Populate the template
    content = test_template.format(
        class_name=class_name,
        class_base_name=class_base_name,
        spec_path=spec_path,
        spec_name=spec_name,
        service_name=service_name,
        schema_name=schema_name,
        path_checks=path_checks,
        property_checks=property_checks,
        schema_base_name=class_base_name,
    )

    # Write the test file
    os.makedirs(base_test_directory, exist_ok=True)
    test_file_path = os.path.join(base_test_directory, test_file)
    with open(test_file_path, "w") as f:
        f.write(content)

print(f"Generated {len(tests)} test files in {base_test_directory}")
