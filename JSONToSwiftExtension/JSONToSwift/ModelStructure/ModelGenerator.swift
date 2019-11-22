//
//  ModelGenerator.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/18.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

/// 模型生成
struct ModelGenerator {
    /**
     Generate a set model files for the given JSON object.

     - parameter object:           Object that has to be parsed.
     - parameter defaultClassName: Default Classname for the object.
     - parameter isTopLevelObject: Is the current object the root object in the JSON.

     - returns: Model files for the current object and sub objects.
     */
    func generateModelForJSON(_ object: JSON, _ defaultClassName: String, _ isTopLevelObject: Bool) -> [ModelFile] {
        let className = CamelNameGenerator.camelName(raw: defaultClassName)
        var modelFiles: [ModelFile] = []

        // Incase the object was NOT a dictionary. (this would only happen in case of the top level
        // object, since internal objects are handled within the function and do not pass an array here)
        if let rootObject = object.array, let firstObject = rootObject.first {
            // TODO: - 暂不支持 object array
            let subClassType = VariableType(with: firstObject)
            // If the type of the first item is an object then make it the base class and generate
            // stuff. However, currently it does not make a base file to handle the array.
            if subClassType == .object {
                return generateModelForJSON(reduce(rootObject), className, isTopLevelObject)
            }
            return []
        }

        if let rootObject = object.dictionary {
            var currentModel = SwiftModel()
            currentModel.fileName = className
            currentModel.sourceJSON = object

            for (key, value) in rootObject {
                let variableName = key
                let variableType = VariableType(with: value)
                let stringConstantName = ""//NameGenerator.variableKey(className, variableName)

                switch variableType {
                case .array:
                    if value.arrayValue.isEmpty {
                        currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, VariableType.array.rawValue, stringConstantName, key, .emptyArray))
                    } else {
                        let subClassType = VariableType(with: value.arrayValue.first!)
                        if subClassType == .object {
                            let models = generateModelForJSON(reduce(value.arrayValue), variableName, false)
                            modelFiles += models
                            let model = models.first
                            let classname = model?.fileName
                            currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, classname!, stringConstantName, key, .objectTypeArray))
                        } else {
                            currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, subClassType.rawValue, stringConstantName, key, .valueTypeArray))
                        }
                    }
                case .object:
                    // TODO: - 优化名字拼接方式方式
                    let className = "\(className)_\(key)"
                    let models = generateModelForJSON(value, className, false)
                    currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, className, stringConstantName, key, .objectType))
                    modelFiles += models
                case .null:
                    currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, VariableType.null.rawValue, stringConstantName, key, .nullType))
                default:
                    currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, variableType.rawValue, stringConstantName, key, .valueType))
                }
            }

            modelFiles = [currentModel] + modelFiles
        }

        // at the end we return the collection of files.
        return modelFiles
    }
    
    /// Reduce an array of JSON objects to a single JSON object with all possible keys (merge all keys into one single object).
    ///
    /// - Parameter items: An array of JSON items that have to be reduced.
    /// - Returns: Reduced JSON with the common key/value pairs.
    func reduce(_ items: [JSON]) -> JSON {
        return items.reduce([:]) { (source, item) -> JSON in
            var finalObject = source
            for (key, jsonValue) in item {
                if let newValue = jsonValue.dictionary {
                    finalObject[key] = reduce([JSON(newValue), finalObject[key]])
                } else if let newValue = jsonValue.array, newValue.first != nil && (newValue.first!.dictionary != nil || newValue.first!.array != nil) {
                    finalObject[key] = JSON([reduce(newValue + finalObject[key].arrayValue)])
                } else if jsonValue != JSON.null || !finalObject[key].exists() {
                    finalObject[key] = jsonValue
                }
            }
            return finalObject
        }
    }
}
