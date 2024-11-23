import Foundation

/// A utility class for resolving `$ref` references within an OpenAPI document.
class ReferenceResolver {
    private let components: ComponentsObject

    /// Initializes the resolver with the `ComponentsObject` where reusable references are stored.
    /// - Parameter components: The reusable components from the OpenAPI document.
    init(components: ComponentsObject) {
        self.components = components
    }

    /// Resolves a `$ref` reference to the actual object.
    /// - Parameter ref: The reference string (e.g., `#/components/schemas/MySchema`).
    /// - Returns: The resolved object, or `nil` if the reference could not be resolved.
    func resolve<T: Codable>(ref: String) -> T? {
        // Check if the reference starts with the expected prefix
        guard ref.hasPrefix("#/components/") else {
            print("Unsupported reference format: \(ref)")
            return nil
        }

        // Split the reference path into components
        let pathComponents = ref.dropFirst("#/".count).components(separatedBy: "/")

        // Ensure the path has at least 3 components to match the expected pattern `#/components/<type>/<name>`
        guard pathComponents.count >= 3 else {
            print("Invalid reference path: \(ref)")
            return nil
        }

        let componentType = pathComponents[1]
        let componentName = pathComponents[2]

        // Retrieve and cast the referenced component based on the type
        switch componentType {
        case "schemas":
            return (components.schemas?[componentName] as? SchemaObject) as? T
        case "responses":
            return (components.responses?[componentName] as? ResponseObject) as? T
        case "parameters":
            return (components.parameters?[componentName] as? ParameterObject) as? T
        case "examples":
            return components.examples?[componentName] as? T
        case "requestBodies":
            return components.requestBodies?[componentName] as? T
        case "headers":
            return components.headers?[componentName] as? T
        case "securitySchemes":
            return components.securitySchemes?[componentName] as? T
        case "links":
            return components.links?[componentName] as? T
        case "callbacks":
            return components.callbacks?[componentName] as? T
        default:
            print("Unknown reference type: \(componentType)")
            return nil
        }
    }
}
