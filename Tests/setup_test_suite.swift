import Foundation

// Paths
let currentDirectory = FileManager.default.currentDirectoryPath
let rootTestDirectory = currentDirectory
let unitDirectory = "\(rootTestDirectory)/Unit"
let integrationDirectory = "\(rootTestDirectory)/Integration"
let specCoverageDirectory = "\(rootTestDirectory)/SpecificationCoverage"
let deprecatedTestsDirectory = "\(rootTestDirectory)/DeprecatedTests"
let oldTestsDirectory = "\(rootTestDirectory)/OpenAPIParserTests"
let modelsDirectory = "../Sources/OpenAPIParserLib/Models"

// Ensure required directories are created
let directories = [unitDirectory, integrationDirectory, specCoverageDirectory, deprecatedTestsDirectory]
for dir in directories {
    try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
}

// Deprecate old tests
if FileManager.default.fileExists(atPath: oldTestsDirectory) {
    do {
        let oldTestFiles = try FileManager.default.contentsOfDirectory(atPath: oldTestsDirectory)
        for testFile in oldTestFiles {
            let oldFilePath = "\(oldTestsDirectory)/\(testFile)"
            let newFilePath = "\(deprecatedTestsDirectory)/\(testFile)"
            try FileManager.default.moveItem(atPath: oldFilePath, toPath: newFilePath)
            print("Deprecated \(testFile) -> Moved to DeprecatedTests/")
        }
    } catch {
        print("Error while deprecating old tests: \(error)")
    }
}

// Dynamically scan for models in the Models directory
guard let modelFiles = try? FileManager.default.contentsOfDirectory(atPath: modelsDirectory) else {
    fatalError("Failed to read models directory at \(modelsDirectory)")
}

let modelNames = modelFiles.compactMap { $0.split(separator: ".").first?.description }

// Create Unit Test files for each model
for model in modelNames {
    let unitTestFilePath = "\(unitDirectory)/\(model)Tests.swift"
    if !FileManager.default.fileExists(atPath: unitTestFilePath) {
        let unitTestContent = """
        import XCTest

        final class \(model)Tests: XCTestCase {
            func testExample() {
                // TODO: Add tests for \(model)
                XCTAssert(true)
            }
        }
        """
        try? unitTestContent.write(toFile: unitTestFilePath, atomically: true, encoding: .utf8)
        print("Created \(unitTestFilePath)")
    }
}

// Create placeholder files for Integration and Specification Coverage
let integrationTestFile = "\(integrationDirectory)/IntegrationTests.swift"
if !FileManager.default.fileExists(atPath: integrationTestFile) {
    let integrationTestContent = """
    import XCTest

    final class IntegrationTests: XCTestCase {
        func testExampleIntegration() {
            // TODO: Add integration tests
            XCTAssert(true)
        }
    }
    """
    try? integrationTestContent.write(toFile: integrationTestFile, atomically: true, encoding: .utf8)
    print("Created \(integrationTestFile)")
}

let specCoverageTestFile = "\(specCoverageDirectory)/SpecificationCoverageTests.swift"
if !FileManager.default.fileExists(atPath: specCoverageTestFile) {
    let specCoverageTestContent = """
    import XCTest

    final class SpecificationCoverageTests: XCTestCase {
        func testSpecificationExample() {
            // TODO: Add specification coverage tests
            XCTAssert(true)
        }
    }
    """
    try? specCoverageTestContent.write(toFile: specCoverageTestFile, atomically: true, encoding: .utf8)
    print("Created \(specCoverageTestFile)")
}

print("Test suite setup completed. Old tests have been deprecated.")
