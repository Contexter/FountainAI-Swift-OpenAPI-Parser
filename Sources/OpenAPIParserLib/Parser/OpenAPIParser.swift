import Foundation
import Yams

enum ParserError: Error {
    case fileNotFound
    case decodingError(Error)
    case unsupportedFormat
    case serializationError(Error)
}

class OpenAPIParser {
    func parse(from data: Data, format: String) throws -> [String: AnyCodable] {
        switch format {
        case "json":
            return try parseJSON(from: data)
        case "yaml", "yml":
            return try parseYAML(from: data)
        default:
            throw ParserError.unsupportedFormat
        }
    }

    private func parseJSON(from data: Data) throws -> [String: AnyCodable] {
        do {
            return try JSONDecoder().decode([String: AnyCodable].self, from: data)
        } catch {
            throw ParserError.decodingError(error)
        }
    }

    private func parseYAML(from data: Data) throws -> [String: AnyCodable] {
        guard let yamlString = String(data: data, encoding: .utf8) else {
            throw ParserError.decodingError(ParserError.fileNotFound)
        }

        do {
            return try YAMLDecoder().decode([String: AnyCodable].self, from: yamlString)
        } catch {
            throw ParserError.decodingError(error)
        }
    }

    /// Serializes an `OpenAPIDocument` to YAML format.
    /// - Parameter document: The `OpenAPIDocument` to serialize.
    /// - Returns: A YAML string representation of the document.
    /// - Throws: An error if serialization fails.
    func serializeToYAML(document: OpenAPIDocument) throws -> String {
        do {
            return try YAMLEncoder().encode(document)
        } catch {
            throw ParserError.serializationError(error)
        }
    }
}
