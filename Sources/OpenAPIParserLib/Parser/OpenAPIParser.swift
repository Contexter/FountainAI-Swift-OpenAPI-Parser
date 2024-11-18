import Foundation

/// A parser responsible for loading and parsing OpenAPI documents.
class OpenAPIParser {
    enum ParserError: Error {
        case fileNotFound
        case invalidData
        case decodingError(Error)
    }

    /// Parses an OpenAPI document from a JSON or YAML file located at a given URL.
    /// - Parameter url: The URL of the OpenAPI document.
    /// - Returns: A decoded `OpenAPIDocument` object.
    func parse(from url: URL) throws -> OpenAPIDocument {
        // Load data from file
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ParserError.fileNotFound
        }

        // Decode data into OpenAPIDocument
        do {
            let document = try JSONDecoder().decode(OpenAPIDocument.self, from: data)
            return document
        } catch {
            throw ParserError.invalidData
        }
    }
}
