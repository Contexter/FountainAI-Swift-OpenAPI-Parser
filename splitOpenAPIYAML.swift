import Foundation

struct YAMLExtractor {
    static func splitOpenAPIYAMLContainer() {
        let sourcePath = "Sources/OpenAPIParserLib/OpenAPI/OpenAPIYAMLContainer.swift"
        let outputDir = "Sources/OpenAPIParserLib/OpenAPI/Containers"

        // Ensure output directory exists
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: outputDir) {
            do {
                try fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create output directory: \(error.localizedDescription)")
                return
            }
        }

        guard let sourceContent = try? String(contentsOfFile: sourcePath) else {
            print("Failed to read source file at \(sourcePath)")
            return
        }

        // Regex to match `static let <name>: String = """..."""`
        let regex = try! NSRegularExpression(
            pattern: #"static let (\w+_yml): String = \"\"\"(.*?)\"\"\""#,
            options: [.dotMatchesLineSeparators]
        )

        let range = NSRange(sourceContent.startIndex..<sourceContent.endIndex, in: sourceContent)
        let matches = regex.matches(in: sourceContent, options: [], range: range)

        guard !matches.isEmpty else {
            print("No YAML definitions found in the source file.")
            return
        }

        for match in matches {
            guard let nameRange = Range(match.range(at: 1), in: sourceContent),
                  let yamlRange = Range(match.range(at: 2), in: sourceContent) else {
                continue
            }

            let name = String(sourceContent[nameRange])
            let yamlContent = String(sourceContent[yamlRange])

            // Generate struct name and file name
            let structName = name.replacingOccurrences(of: "_yml", with: "").capitalized
            let fileName = "\(structName).swift"
            let outputPath = "\(outputDir)/\(fileName)"

            // Write to new file
            let fileContent = """
            // Auto-generated from OpenAPIYAMLContainer.swift
            // This file contains the OpenAPI YAML definition for \(structName)

            import Foundation

            struct \(structName) {
                /// The OpenAPI YAML definition
                static let yaml: String = \"\"\"\(yamlContent)\"\"\"
            }
            """

            do {
                try fileContent.write(toFile: outputPath, atomically: true, encoding: .utf8)
                print("Created: \(outputPath)")
            } catch {
                print("Failed to write file \(fileName): \(error.localizedDescription)")
            }
        }

        print("All OpenAPI YAML definitions have been successfully split.")
    }
}

// Run the script
YAMLExtractor.splitOpenAPIYAMLContainer()

