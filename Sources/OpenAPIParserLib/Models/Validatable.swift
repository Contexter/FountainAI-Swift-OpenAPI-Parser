// Validatable.swift
import Foundation

protocol Validatable {
    func nestedValidate() throws
}

extension Validatable {
    func nestedValidate() throws {
        // Default validation logic
    }
}
