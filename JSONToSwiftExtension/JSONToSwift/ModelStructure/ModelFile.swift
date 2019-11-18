//
//  ModelFile.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/18.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

/// A protocol defining the structure of the model file.
protocol ModelFile {
    /// Filename for the model.
    var fileName: String { get set }

    /// Original JSON source file used for generating this model.
    var sourceJSON: JSON { get set }
    
    /// Storage for various components of the model, it is used to store the intermediate data.
    var component: ModelComponent { get }

    /// Generate various required components for the given property.
    ///
    /// - Parameter property: Property for which components are to be generated.
    mutating func generateAndAddComponentsFor(_ property: PropertyComponent)
}

/// 最终的模型文件
struct SwiftModel: ModelFile {
    var fileName: String
    var component: ModelComponent
    var sourceJSON: JSON

    // MARK: - Initialisers.

    init() {
        fileName = ""
        component = ModelComponent()
        sourceJSON = JSON([])
    }

    mutating func generateAndAddComponentsFor(_ property: PropertyComponent) {
        let isOptional = false
        let isArray = property.propertyType == .valueTypeArray || property.propertyType == .objectTypeArray
        let isObject = property.propertyType == .objectType || property.propertyType == .objectTypeArray
        let type = property.propertyType == .emptyArray ? "Any" : property.type

        switch property.propertyType {
        case .valueType, .valueTypeArray, .objectType, .objectTypeArray, .emptyArray:
            component.stringConstants.append(genStringConstant(property.constantName, property.key))
            component.declarations.append(genVariableDeclaration(property.name, type, isArray, isOptional))
            component.initialisers.append(genInitializerForVariable(name: property.name, type: property.type, constantName: property.constantName, isOptional: isOptional, isArray: isArray, isObject: isObject))
        case .nullType:
            // Currently we do not deal with null values.
            break
        }
    }

    /// Format the incoming string is in the case format.
    ///
    /// - Parameters:
    ///   - constantName: Constant value to represent the variable.
    ///   - value: Value for the key that is used in the JSON.
    /// - Returns: Returns `case <constant> = "value"`.
    func genStringConstant(_ constantName: String, _ value: String) -> String {
        let component = constantName.components(separatedBy: ".")
        let caseName = component.last!
        return "case \(caseName)" + (caseName == value ? "" : " = \"\(value)\"")
    }

    /// Generate the variable declaration string
    ///
    /// - Parameters:
    ///   - name: variable name to be used
    ///   - type: variable type to use
    ///   - isArray: Is the value an object
    ///   - isOptional: Is optional variable kind
    /// - Returns: A string to use as the declration
    func genVariableDeclaration(_ name: String, _ type: String, _ isArray: Bool, _ isOptional: Bool) -> String {
        var internalType = type
        if isArray {
            internalType = "[\(type)]"
        }
        return genPrimitiveVariableDeclaration(name, internalType, isOptional)
    }

    func genPrimitiveVariableDeclaration(_ name: String, _ type: String, _ isOptional: Bool) -> String {
        if isOptional {
            return "var \(name): \(type)?"
        }
        return "var \(name): \(type)"
    }

    func genInitializerForVariable(name: String, type: String, constantName: String, isOptional: Bool, isArray: Bool, isObject _: Bool) -> String {
        var variableType = type
        if isArray {
            variableType = "[\(type)]"
        }
        let component = constantName.components(separatedBy: ".")
        let decodeMethod = isOptional ? "decodeIfPresent" : "decode"
        return "\(name) = try container.\(decodeMethod)(\(variableType).self, forKey: .\(component.last!))"
    }
}

