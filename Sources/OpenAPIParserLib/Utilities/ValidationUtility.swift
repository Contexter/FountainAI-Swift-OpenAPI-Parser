import Foundation

/// A utility class for validating OpenAPI document elements.
class ValidationUtility {
    /// Validates that a given string is not empty or nil.
    /// - Parameter string: The string to validate.
    /// - Returns: `true` if the string is valid; otherwise, `false`.
    static func validateNonEmptyString(_ string: String?) -> Bool {
        guard let string = string else { return false }
        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Validates that a given URL is well-formed.
    /// - Parameter urlString: The URL string to validate.
    /// - Returns: `true` if the URL is valid; otherwise, `false`.
    static func validateURL(_ urlString: String?) -> Bool {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return false
        }
        return url.scheme != nil && url.host != nil
    }

    /// Validates that an OpenAPI component reference is in the correct format (`#/components/<type>/<name>`).
    /// - Parameter ref: The reference string to validate.
    /// - Returns: `true` if the reference is in a valid format; otherwise, `false`.
    static func validateReferenceFormat(_ ref: String?) -> Bool {
        guard let ref = ref else { return false }
        return ref.hasPrefix("#/components/") && ref.components(separatedBy: "/").count >= 3
    }

    /// Validates that a required property is not nil.
    /// - Parameter value: The value to check.
    /// - Returns: `true` if the value is not nil; otherwise, `false`.
    static func validateRequiredProperty<T>(_ value: T?) -> Bool {
        value != nil
    }

    /// Validates that an array is not empty or nil.
    /// - Parameter array: The array to validate.
    /// - Returns: `true` if the array is valid; otherwise, `false`.
    static func validateNonEmptyArray<T>(_ array: [T]?) -> Bool {
        guard let array = array else { return false }
        return !array.isEmpty
    }

    /// Runs validations on a schema object to ensure required fields are present.
    /// - Parameter schema: The `SchemaObject` to validate.
    /// - Returns: `true` if the schema passes validation; otherwise, `false`.
    static func validateSchema(_ schema: SchemaObject) -> Bool {
        // Example validation rules for a schema
        guard validateNonEmptyString(schema.title) else {
            print("Validation Error: Schema title is required.")
            return false
        }

        // Ensure that the schema type is not nil
        guard let _ = schema.type else {
            print("Validation Error: Schema type cannot be nil.")
            return false
        }

        // Add other schema-specific validation rules as needed
        return true
    }
}
