//
//  JSONComponent.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/15.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation

/// A strucutre to store various attributes related to a single property.
struct PropertyComponent {
    /// Name of the property.
    var name: String
    /// Type of the property.
    var type: String
    /// Constant name that is to be used to encode, decode and read from JSON.
    var constantName: String
    /// Original key in the JSON file.
    var key: String
    /// Nature of the property, if it is a value type, an array of a value type or an object.
    var propertyType: PropertyType

    /// Initialise a property component.
    ///
    /// - Parameters:
    ///   - name: Name of the property.
    ///   - type: Type of the property.
    ///   - constantName: Constant name that is to be used to encode, decode and read from JSON.
    ///   - key: Original key in the JSON file.
    ///   - propertyType: Nature of the property, if it is a value type, an array of a value type or an object.
    init(_ name: String, _ type: String, _ constantName: String, _ key: String, _ propertyType: PropertyType) {
        self.name = name
        self.type = type
        self.constantName = constantName
        self.key = key
        self.propertyType = propertyType
    }
}
