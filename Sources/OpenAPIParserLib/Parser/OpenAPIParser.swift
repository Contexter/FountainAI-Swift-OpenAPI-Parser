import Foundation
import Yams

/// Enum representing potential errors encountered during parsing or serialization.
enum ParserError: Error {
    case fileNotFound                 // Error for missing file.
    case decodingError(Error)         // Error during decoding (JSON or YAML).
    case unsupportedFormat            // Error for unsupported formats.
    case serializationError(Error)    // Error during serialization.
}

/// A utility class for parsing OpenAPI specifications in JSON or YAML format,
/// and serializing them back to YAML.
class OpenAPIParser {

    /// Parses data in a specified format (JSON or YAML) and returns a dictionary representation.
    ///
    /// - Parameters:
    ///   - data: The raw data to parse.
    ///   - format: The format of the input data ("json" or "yaml").
    /// - Returns: A dictionary representation of the parsed OpenAPI document.
    /// - Throws: `ParserError` if parsing fails or the format is unsupported.
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

    /// Parses JSON data into a dictionary representation.
    ///
    /// - Parameter data: JSON data to parse.
    /// - Returns: A dictionary representation of the parsed data.
    /// - Throws: `ParserError.decodingError` if decoding fails.
    private func parseJSON(from data: Data) throws -> [String: AnyCodable] {
        do {
            return try JSONDecoder().decode([String: AnyCodable].self, from: data)
        } catch {
            throw ParserError.decodingError(error)
        }
    }

    /// Parses YAML data into a dictionary representation.
    ///
    /// - Parameter data: YAML data to parse.
    /// - Returns: A dictionary representation of the parsed data.
    /// - Throws: `ParserError.decodingError` if decoding fails.
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

    /// Parses data into a strongly-typed `OpenAPIDocument` object.
    ///
    /// - Parameters:
    ///   - data: The raw data to parse.
    ///   - format: The format of the input data ("json" or "yaml").
    /// - Returns: A strongly-typed `OpenAPIDocument` representation of the parsed data.
    /// - Throws: `ParserError` if parsing fails or the format is unsupported.
    func parseDocument(from data: Data, format: String) throws -> OpenAPIDocument {
        let parsedData = try parse(from: data, format: format)

        // Convert parsed dictionary into an OpenAPIDocument using a custom decoder.
        // Ensure this is aligned with your `OpenAPIDocument` structure.
        let decoder = JSONDecoder()
        let jsonData = try JSONSerialization.data(withJSONObject: parsedData, options: [])
        return try decoder.decode(OpenAPIDocument.self, from: jsonData)
    }

    /// Serializes an `OpenAPIDocument` to YAML format.
    ///
    /// - Parameter document: The `OpenAPIDocument` to serialize.
    /// - Returns: A YAML string representation of the document.
    /// - Throws: `ParserError.serializationError` if serialization fails.
    func serializeToYAML(document: OpenAPIDocument) throws -> String {
        do {
            return try YAMLEncoder().encode(document)
        } catch {
            throw ParserError.serializationError(error)
        }
    }
}
