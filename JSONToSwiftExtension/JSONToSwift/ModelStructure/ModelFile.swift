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
    var component: ModelComponents { get }

    /// Generate various required components for the given property.
    ///
    /// - Parameter property: Property for which components are to be generated.
    mutating func generateAndAddComponentsFor(_ property: PropertyComponent)
}

/// 最终的模型文件
struct SwiftModel: ModelFile {
    
    var fileName = ""
    var component = ModelComponents()
    var sourceJSON = JSON([])
    
    mutating func generateAndAddComponentsFor(_ property: PropertyComponent) {
        // TODO: - 之后增加 optional 配置
        let isArray = property.propertyType == .valueTypeArray || property.propertyType == .objectTypeArray
        let isObject = property.propertyType == .objectType || property.propertyType == .objectTypeArray
        let type = property.propertyType == .emptyArray ? "Any" : property.type

        switch property.propertyType {
        case .valueType, .valueTypeArray, .objectType, .objectTypeArray, .emptyArray:
            let item = genVariableDeclaration(name: property.name, type: type, isArray: isArray, isObject: isObject)
            component.list.append(item)
        case .nullType:
            // Currently we do not deal with null values.
            break
        }
    }

    /// 获取名称及类型
    func genVariableDeclaration(name: String, type: String, isArray: Bool, isObject: Bool) -> ModelComponent {
        var internalType = type
        if isObject {
            internalType = CamelNameGenerator.camelName(raw: type)
        }
        if isArray {
            internalType = "[\(type)]"
        }
        return ModelComponent(name: CamelNameGenerator.camelName(raw: name), type: internalType, map: name)
    }
}

