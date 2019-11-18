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
        let className = defaultClassName//NameGenerator.fixClassName(defaultClassName, configuration.prefix, isTopLevelObject)
        var modelFiles: [ModelFile] = []

        // Incase the object was NOT a dictionary. (this would only happen in case of the top level
        // object, since internal objects are handled within the function and do not pass an array here)
        if let rootObject = object.array, let firstObject = rootObject.first {
            // TODO: - 暂不支持 object array
            let subClassType = VariableType(with: firstObject)
            // If the type of the first item is an object then make it the base class and generate
            // stuff. However, currently it does not make a base file to handle the array.
//            if subClassType == .object {
//                return generateModelForJSON(JSONHelper.reduce(rootObject), defaultClassName, isTopLevelObject)
//            }
            return []
        }

        if let rootObject = object.dictionary {
            // A model file to store the current model.
            var currentModel = SwiftModel()
            currentModel.sourceJSON = object

            for (key, value) in rootObject {
                /// basic information, name, type and the constant to store the key.
                let variableName = defaultClassName//NameGenerator.fixVariableName(key)
                let variableType = VariableType(with: value)
                let stringConstantName = ""//NameGenerator.variableKey(className, variableName)

                switch variableType {
                case .array:
                    if value.arrayValue.isEmpty {
                        currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, VariableType.array.rawValue, stringConstantName, key, .emptyArray))
                    } else {
                        let subClassType = VariableType(with: value.arrayValue.first!)
                        if subClassType == .object {
                            // TODO: - 暂不支持 object array
//                            let models = generateModelForJSON(JSONHelper.reduce(value.arrayValue), variableName, false)
//                            modelFiles += models
//                            let model = models.first
//                            let classname = model?.fileName
//                            currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, classname!, stringConstantName, key, .objectTypeArray))
                        } else {
                            currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, subClassType.rawValue, stringConstantName, key, .valueTypeArray))
                        }
                    }
                case .object:
                    let models = generateModelForJSON(value, variableName, false)
                    let model = models.first
                    let typeName = model?.fileName
                    currentModel.generateAndAddComponentsFor(PropertyComponent(variableName, typeName!, stringConstantName, key, .objectType))
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
}
