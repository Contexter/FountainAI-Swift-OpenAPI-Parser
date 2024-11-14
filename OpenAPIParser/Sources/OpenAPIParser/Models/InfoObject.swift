import Foundation

/// Represents metadata about the API, including title, description, version, and other information.
struct InfoObject: Codable {
    let title: String
    let description: String?
    let termsOfService: URL?
    let contact: ContactObject?
    let license: LicenseObject?
    let version: String
    
    init(title: String,
         description: String? = nil,
         termsOfService: URL? = nil,
         contact: ContactObject? = nil,
         license: LicenseObject? = nil,
         version: String) {
        self.title = title
        self.description = description
        self.termsOfService = termsOfService
        self.contact = contact
        self.license = license
        self.version = version
    }
}

/// Contact information for the exposed API.
struct ContactObject: Codable {
    let name: String?
    let url: URL?
    let email: String?
}

/// License information for the API.
struct LicenseObject: Codable {
    let name: String
    let url: URL?
}
