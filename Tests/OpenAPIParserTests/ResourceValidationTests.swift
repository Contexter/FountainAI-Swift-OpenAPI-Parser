import XCTest

final class ResourceValidationTests: XCTestCase {
    func testAllResourcesExist() {
        // Define the resource paths to check
        let resourcePaths = [
            "Sources/OpenAPIParserLib/OpenAPI/Action-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Story-Factory-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Core-Script-Managment-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Ensemble-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Performer-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Central-Sequence-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Session-And-Context-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Spoken-Word-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Paraphrase-Service.yml",
            "Sources/OpenAPIParserLib/OpenAPI/Character-Service.yml",
            "Tests/OpenAPIParserTests/sample.yaml",
            "Tests/OpenAPIParserTests/sample.json"
        ]
        
        // Loop through each path and check if the file exists
        for resourcePath in resourcePaths {
            XCTAssertTrue(FileManager.default.fileExists(atPath: resourcePath),
                          "❌ Resource file is missing: \(resourcePath)")
        }
    }
}

