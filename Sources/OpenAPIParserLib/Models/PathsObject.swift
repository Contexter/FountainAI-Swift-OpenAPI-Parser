import Foundation

/// Represents the paths and operations available in the API.
struct PathsObject: Codable {
    let paths: [String: OpenAPIPathItemObject]

    init(paths: [String: OpenAPIPathItemObject]) {
        self.paths = paths
    }
}

/// Represents a single API path and its available HTTP methods.
struct OpenAPIPathItemObject: Codable {
    let summary: String?
    let description: String?
    let get: OperationObject?
    let put: OperationObject?
    let post: OperationObject?
    let delete: OperationObject?
    let options: OperationObject?
    let head: OperationObject?
    let patch: OperationObject?
    let trace: OperationObject?
    let servers: [ServerObject]?
    let parameters: [ParameterObject]?

    init(summary: String? = nil,
         description: String? = nil,
         get: OperationObject? = nil,
         put: OperationObject? = nil,
         post: OperationObject? = nil,
         delete: OperationObject? = nil,
         options: OperationObject? = nil,
         head: OperationObject? = nil,
         patch: OperationObject? = nil,
         trace: OperationObject? = nil,
         servers: [ServerObject]? = nil,
         parameters: [ParameterObject]? = nil)
    {
        self.summary = summary
        self.description = description
        self.get = get
        self.put = put
        self.post = post
        self.delete = delete
        self.options = options
        self.head = head
        self.patch = patch
        self.trace = trace
        self.servers = servers
        self.parameters = parameters
    }
}

extension PathsObject {
    subscript(path: String) -> PathItemObject? {
        return self.getPath(path)
    }
}

extension PathsObject {
    func getPath(_ path: String) -> PathItemObject? {
        guard let openAPIPathItem = paths[path] else {
            return nil
        }
        
        // Encode the OpenAPIPathItemObject into JSON data and decode it into a PathItemObject
        do {
            let jsonData = try JSONEncoder().encode(openAPIPathItem)
            return try JSONDecoder().decode(PathItemObject.self, from: jsonData)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
}
