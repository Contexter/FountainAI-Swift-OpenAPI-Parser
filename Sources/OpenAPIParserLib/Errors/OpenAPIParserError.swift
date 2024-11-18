import Foundation

enum OpenAPIParserError: LocalizedError {
    case invalidVersion(String)
    case missingRequiredField(String)
    case invalidReference(String)
    case missingReference(String)
    case invalidSchema(String)
    case invalidURL(String)
    case missingContent(String)
    case invalidPath(String)
    case missingDescription(String)

    var errorDescription: String? {
        switch self {
        case let .invalidVersion(message): return "Invalid version: \(message)"
        case let .missingRequiredField(message): return "Missing required field: \(message)"
        case let .invalidReference(message): return "Invalid reference: \(message)"
        case let .missingReference(message): return "Missing reference: \(message)"
        case let .invalidSchema(message): return "Invalid schema: \(message)"
        case let .invalidURL(message): return "Invalid URL: \(message)"
        case let .missingContent(message): return "Missing content: \(message)"
        case let .invalidPath(message): return "Invalid path: \(message)"
        case let .missingDescription(message): return "Missing description: \(message)"
        }
    }
}
