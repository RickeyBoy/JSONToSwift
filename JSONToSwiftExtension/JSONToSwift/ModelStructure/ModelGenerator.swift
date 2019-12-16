//
//  ModelGenerator.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/18.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

/// 模型生成
struct ModelGenerator {
    
    /// 根据 JSON 生成对应的最终 swift 模型
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

                switch variableType {
                case .array:
                    if value.arrayValue.isEmpty {
                        // 空数组
                        currentModel.generateComponents(with: PropertyComponent(variableName, VariableType.array.rawValue, VariableType.array.defaultValue, key, .emptyArray))
                    } else {
                        let subClassType = VariableType(with: value.arrayValue.first!)
                        if subClassType == .object {
                            // subclass 数组
                            let models = generateModelForJSON(reduce(value.arrayValue), variableName, false)
                            modelFiles += models
                            let model = models.first
                            let classname = model?.fileName
                            currentModel.generateComponents(with: PropertyComponent(variableName, classname!, VariableType.array.defaultValue, key, .objectTypeArray))
                        } else {
                            // 值数组
                            currentModel.generateComponents(with: PropertyComponent(variableName, subClassType.rawValue, VariableType.array.defaultValue, key, .valueTypeArray))
                        }
                    }
                case .object:
                    // TODO: - 优化名字拼接方式方式
                    let className = "\(className)_\(key)"
                    let models = generateModelForJSON(value, className, false)
                    // subclass 映射
                    currentModel.generateComponents(with: PropertyComponent(variableName, className, VariableType.object.defaultValue, key, .objectType))
                    modelFiles += models
                case .null:
                    // 无法识别的情况
                    currentModel.generateComponents(with: PropertyComponent(variableName, VariableType.null.rawValue, VariableType.null.defaultValue, key, .nullType))
                default:
                    // 默认：值映射
                    currentModel.generateComponents(with: PropertyComponent(variableName, variableType.rawValue, variableType.defaultValue, key, .valueType))
                }
            }

            modelFiles = [currentModel] + modelFiles
        }

        // at the end we return the collection of files.
        return modelFiles
    }
    
    /// Reduce an array of JSON objects to a single JSON object with all possible keys (merge all keys into one single object).
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
