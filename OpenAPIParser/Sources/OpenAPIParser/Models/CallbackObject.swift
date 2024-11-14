import Foundation

/// Represents a callback, which defines a set of possible requests that the server may initiate.
struct CallbackObject: Codable {
    let callbacks: [String: PathItemObject]

    init(callbacks: [String: PathItemObject]) {
        self.callbacks = callbacks
    }
}
