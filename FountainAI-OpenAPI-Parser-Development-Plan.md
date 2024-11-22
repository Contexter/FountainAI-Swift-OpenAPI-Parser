
# Project Development Plan: Extending FountainAI-Swift-OpenAPI-Parser

## Overview
This document outlines the plan to extend the functionality of the `FountainAI-Swift-OpenAPI-Parser` library to provide OpenAPI document merging and saving capabilities. The proposed changes will be implemented non-destructively, ensuring backward compatibility with the existing API.

---

## Goals

1. **Add OpenAPI Document Merging Functionality:**
   - Support merging `paths`, `components.schemas`, and other OpenAPI properties non-destructively.
   - Handle conflicts gracefully, with informative warnings for duplicate entries.

2. **Enable Saving of OpenAPI Documents:**
   - Provide functionality to save OpenAPI documents in YAML or JSON format.

3. **Maintain Backward Compatibility:**
   - Extend the library without modifying its core functionality.

4. **Ensure Robust Testing:**
   - Write comprehensive test cases for the new features to maintain code reliability.

---

## Implementation Steps

### Step 1: Add `merge` Method to `OpenAPIDocument`
Extend the `OpenAPIDocument` struct with a method to merge another document into the current instance.

**File:** `Sources/OpenAPIParserLib/Models/OpenAPIDocument.swift`

```swift
extension OpenAPIDocument {
    /// Merges another OpenAPIDocument into this one.
    /// - Parameter other: The OpenAPIDocument to merge.
    /// - Throws: An error if merging fails.
    public mutating func merge(with other: OpenAPIDocument) throws {
        // Merge paths
        for (path, pathItem) in other.paths.paths {
            if self.paths.paths[path] == nil {
                self.paths.paths[path] = pathItem
            } else {
                print("⚠️ Path conflict: \(path) exists in both documents. Skipping.")
            }
        }

        // Merge schemas
        if let otherSchemas = other.components?.schemas,
           var selfSchemas = self.components?.schemas {
            for (schemaName, schemaObject) in otherSchemas {
                if selfSchemas[schemaName] == nil {
                    selfSchemas[schemaName] = schemaObject
                } else {
                    print("⚠️ Schema conflict: \(schemaName) exists in both documents. Skipping.")
                }
            }
            self.components?.schemas = selfSchemas
        }
    }
}
```

---

### Step 2: Add `merge` Functionality to `OpenAPIParser`
Extend the `OpenAPIParser` class to merge two OpenAPI documents from file URLs.

**File:** `Sources/OpenAPIParserLib/Parser/OpenAPIParser.swift`

```swift
extension OpenAPIParser {
    /// Merges two OpenAPI documents from file URLs.
    /// - Parameters:
    ///   - url1: The URL of the first OpenAPI document.
    ///   - url2: The URL of the second OpenAPI document.
    /// - Returns: A merged OpenAPIDocument.
    /// - Throws: An error if parsing or merging fails.
    public func merge(from url1: URL, and url2: URL) throws -> OpenAPIDocument {
        let document1 = try parse(from: url1)
        let document2 = try parse(from: url2)

        var mergedDocument = document1
        try mergedDocument.merge(with: document2)
        return mergedDocument
    }
}
```

---

### Step 3: Add `save` Method to `OpenAPIDocument`
Add a method to save an OpenAPI document to a file in JSON or YAML format.

**File:** `Sources/OpenAPIParserLib/Models/OpenAPIDocument.swift`

```swift
import Yams

extension OpenAPIDocument {
    /// Saves the OpenAPI document to a specified file path.
    /// - Parameters:
    ///   - path: The file path to save the document to.
    ///   - format: The format to save the document in (`json` or `yaml`).
    /// - Throws: An error if saving fails.
    public func save(to path: String, format: String = "yaml") throws {
        let encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            return encoder
        }()

        let data: Data
        if format == "json" {
            data = try encoder.encode(self)
        } else if format == "yaml" {
            let yamlString = try Yams.dump(object: self)
            guard let yamlData = yamlString.data(using: .utf8) else {
                throw NSError(domain: "OpenAPIDocumentError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode YAML"])
            }
            data = yamlData
        } else {
            throw NSError(domain: "OpenAPIDocumentError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported format: \(format)"])
        }

        try data.write(to: URL(fileURLWithPath: path))
    }
}
```

---

### Step 4: Add Unit Tests
Write test cases to verify the merging and saving functionalities.

**File:** `Tests/OpenAPIParserTests/MergerTests.swift`

```swift
import XCTest
@testable import OpenAPIParserLib

final class MergerTests: XCTestCase {
    func testMergeOpenAPIDocuments() throws {
        let parser = OpenAPIParser()
        let url1 = URL(fileURLWithPath: "path/to/source.yml")
        let url2 = URL(fileURLWithPath: "path/to/additions.yml")

        let mergedDocument = try parser.merge(from: url1, and: url2)
        XCTAssertNotNil(mergedDocument.paths)
        XCTAssertNotNil(mergedDocument.components?.schemas)
    }

    func testSaveMergedDocument() throws {
        let parser = OpenAPIParser()
        let url1 = URL(fileURLWithPath: "path/to/source.yml")
        let url2 = URL(fileURLWithPath: "path/to/additions.yml")
        let outputPath = "path/to/output.yml"

        let mergedDocument = try parser.merge(from: url1, and: url2)
        try mergedDocument.save(to: outputPath, format: "yaml")

        XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath))
    }
}
```

---

### Step 5: Documentation
Update the library’s README to document the new functionality:

- How to merge OpenAPI documents.
- How to save merged documents.

---

## Release Plan

1. **Development:** Implement the new features and validate functionality.
2. **Testing:** Ensure all new and existing test cases pass.
3. **Release:** Publish the changes under a new version tag (e.g., `v1.1.0`).

---

## Future Enhancements

- Resolve `$ref` references in OpenAPI documents during merging.
- Add conflict resolution strategies for merging paths and schemas.

---

## Conclusion
This development plan ensures that the `FountainAI-Swift-OpenAPI-Parser` library is extended with powerful OpenAPI document merging and saving capabilities, all while preserving backward compatibility and adhering to best practices.
