import Foundation
import Yams

func main() {
    let arguments = CommandLine.arguments
    guard arguments.count > 1 else {
        print("Usage: openapi-parser <path_to_openapi_file>")
        exit(1)
    }

    let filePath = arguments[1]
    let url = URL(fileURLWithPath: filePath)
    var openAPIDocument: OpenAPIDocument? // Declare openAPIDocument here

    do {
        print("File path provided: \(filePath)")
        print("Attempting to read data from file...")

        let data = try Data(contentsOf: url)
        print("Data successfully read from file.")
        
        if filePath.hasSuffix(".yaml") || filePath.hasSuffix(".yml") {
            let yamlString = String(data: data, encoding: .utf8)!
            let yamlObject = try Yams.load(yaml: yamlString) as? [String: Any]
            print("YAML Object Loaded:", yamlObject ?? "nil")
            
            // Check if essential sections exist
            print("Checking for essential fields in the YAML object:")
            print("openapi:", yamlObject?["openapi"] ?? "Missing")
            print("info:", yamlObject?["info"] ?? "Missing")
            print("paths:", yamlObject?["paths"] ?? "Missing")
            print("components:", yamlObject?["components"] ?? "Missing")

            // Convert to JSON data and log it for debugging
            let jsonData = try JSONSerialization.data(withJSONObject: yamlObject!, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Generated JSON from YAML:\n\(jsonString)")
            }
            
            // Try decoding into OpenAPIDocument
            openAPIDocument = try JSONDecoder().decode(OpenAPIDocument.self, from: jsonData)
        } else {
            print("Unsupported file type. Use .json or .yaml.")
            exit(1)
        }

        print("Validating OpenAPI document...")
        if openAPIDocument?.validate() == true {
            print("OpenAPI document is valid.")
        } else {
            print("OpenAPI document is invalid.")
            exit(1)
        }
    } catch {
        print("Error during parsing or validation: \(error.localizedDescription)")
        exit(1)
    }
}

main()
