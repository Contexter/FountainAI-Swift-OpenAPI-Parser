import Foundation

// Directories
let rootTestsDirectory = FileManager.default.currentDirectoryPath
let modelsDirectory = "../Sources/OpenAPIParserLib/Models"
let containersDirectory = "../Sources/OpenAPIParserLib/OpenAPI/Containers"
let newTestsDirectory = "\(rootTestsDirectory)/OpenAPIParserLibTests"

// Remove old tests directory
func removeOldTests() {
    let oldTestsDir = "\(rootTestsDirectory)/OpenAPIParserTests"
    do {
        if FileManager.default.fileExists(atPath: oldTestsDir) {
            try FileManager.default.removeItem(atPath: oldTestsDir)
            print("Old test directory removed: \(oldTestsDir)")
        }
    } catch {
        print("Failed to remove old test directory: \(error)")
    }
}

// Create new test directories
func createTestDirectories() {
    let subDirectories = ["Unit", "Integration", "SpecificationCoverage"]
    for subDir in subDirectories {
        let fullPath = "\(newTestsDirectory)/\(subDir)"
        do {
            try FileManager.default.createDirectory(atPath: fullPath, withIntermediateDirectories: true, attributes: nil)
            print("Created directory: \(fullPath)")
        } catch {
            print("Failed to create directory \(fullPath): \(error)")
        }
    }
}

// Scan models and generate unit test files
func createUnitTests() {
    guard let modelFiles = try? FileManager.default.contentsOfDirectory(atPath: modelsDirectory) else {
        print("Failed to scan models directory.")
        return
    }
    let unitTestsPath = "\(newTestsDirectory)/Unit"
    for modelFile in modelFiles where modelFile.hasSuffix(".swift") {
        let modelName = modelFile.replacingOccurrences(of: ".swift", with: "")
        let testFilePath = "\(unitTestsPath)/\(modelName)Tests.swift"
        let testContent = """
        import XCTest
        @testable import OpenAPIParserLib

        final class \(modelName)Tests: XCTestCase {
            func testExample() {
                // Add test implementation for \(modelName)
            }
        }
        """
        do {
            try testContent.write(toFile: testFilePath, atomically: true, encoding: .utf8)
            print("Created test file: \(testFilePath)")
        } catch {
            print("Failed to write test file \(testFilePath): \(error)")
        }
    }
}

// Scan containers and generate YAML accessors
func createYAMLAccessors() {
    guard let containerFiles = try? FileManager.default.contentsOfDirectory(atPath: containersDirectory) else {
        print("Failed to scan containers directory.")
        return
    }
    let yamlAccessorsFile = "\(containersDirectory)/YAMLAccessors.swift"
    let yamlContent = containerFiles
        .filter { $0.hasSuffix(".swift") }
        .map { containerFile in
            let containerName = containerFile.replacingOccurrences(of: ".swift", with: "")
            return """
            public static var \(containerName.lowercased()): String {
                return \(containerName).yaml
            }
            """
        }
        .joined(separator: "\n\n")
    let fullYAMLContent = """
    import Foundation

    public struct YAMLAccessors {
    \(yamlContent)
    }
    """
    do {
        try fullYAMLContent.write(toFile: yamlAccessorsFile, atomically: true, encoding: .utf8)
        print("YAML accessors generated.")
    } catch {
        print("Failed to write YAML accessors file: \(error)")
    }
}

// Update Package.swift file
func updatePackageFile() {
    let packageFilePath = "../Package.swift"
    let newPackageContent = """
    // swift-tools-version:5.5
    import PackageDescription

    let package = Package(
        name: "OpenAPIParser",
        platforms: [
            .macOS(.v10_15),
        ],
        products: [
            .library(name: "OpenAPIParserLib", targets: ["OpenAPIParserLib"]),
        ],
        dependencies: [
            .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.0")
        ],
        targets: [
            .target(
                name: "OpenAPIParserLib",
                dependencies: [
                    "Yams"
                ],
                path: "Sources/OpenAPIParserLib"
            ),
            .testTarget(
                name: "OpenAPIParserLibTests",
                dependencies: ["OpenAPIParserLib"],
                path: "Tests/OpenAPIParserLibTests"
            ),
        ]
    )
    """
    do {
        try newPackageContent.write(toFile: packageFilePath, atomically: true, encoding: .utf8)
        print("Updated Package.swift file.")
    } catch {
        print("Failed to update Package.swift file: \(error)")
    }
}

// Main script execution
removeOldTests()
createTestDirectories()
createUnitTests()
createYAMLAccessors()
updatePackageFile()
