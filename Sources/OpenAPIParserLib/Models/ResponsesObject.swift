
class ResponsesObject {
    var responses: [String: ResponseObject] = [:]

    subscript(responseCode: String) -> ResponseObject? {
        return self.responses[responseCode]
    }
}
