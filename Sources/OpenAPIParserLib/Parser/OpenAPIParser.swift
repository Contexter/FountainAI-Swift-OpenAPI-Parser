
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

            let yamlObject = try YAMLDecoder().decode([String: AnyCodable].self, from: yamlString)
            let jsonData = try JSONSerialization.data(withJSONObject: yamlObject, options: [])
            return try JSONDecoder().decode(OpenAPIDocument.self, from: jsonData)
        } catch {
            throw ParserError.decodingError(error)
        }
    }
}
