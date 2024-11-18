import Foundation

/// Represents a security requirement for an operation or OpenAPI document.
struct SecurityRequirementObject: Codable {
    let requirements: [String: [String]]

    init(requirements: [String: [String]]) {
        self.requirements = requirements
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var requirementsDict = [String: [String]]()

        for key in container.allKeys {
            let scopes = try container.decode([String].self, forKey: key)
            requirementsDict[key.stringValue] = scopes
        }

        requirements = requirementsDict
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (key, scopes) in requirements {
            try container.encode(scopes, forKey: DynamicCodingKeys(stringValue: key)!)
        }
    }
}
