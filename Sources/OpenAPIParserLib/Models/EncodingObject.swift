import Foundation

/// Represents encoding options for individual properties in multipart request bodies.
struct EncodingObject: Codable {
    let contentType: String?
    let headers: [String: HeaderObject]?
    let style: String?
    let explode: Bool?
    let allowReserved: Bool?

    init(contentType: String? = nil,
         headers: [String: HeaderObject]? = nil,
         style: String? = nil,
         explode: Bool? = nil,
         allowReserved: Bool? = nil)
    {
        self.contentType = contentType
        self.headers = headers
        self.style = style
        self.explode = explode
        self.allowReserved = allowReserved
    }
}
