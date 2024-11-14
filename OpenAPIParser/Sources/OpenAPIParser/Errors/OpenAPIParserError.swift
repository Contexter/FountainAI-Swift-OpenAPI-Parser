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
        case .invalidVersion(let message): return "Invalid version: \(message)"
        case .missingRequiredField(let message): return "Missing required field: \(message)"
        case .invalidReference(let message): return "Invalid reference: \(message)"
        case .missingReference(let message): return "Missing reference: \(message)"
        case .invalidSchema(let message): return "Invalid schema: \(message)"
        case .invalidURL(let message): return "Invalid URL: \(message)"
        case .missingContent(let message): return "Missing content: \(message)"
        case .invalidPath(let message): return "Invalid path: \(message)"
        case .missingDescription(let message): return "Missing description: \(message)"
        }
    }
}
