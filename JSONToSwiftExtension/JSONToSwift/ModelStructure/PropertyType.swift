//
//  PropertyType.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/15.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation

/// 解析后的变量类型
enum PropertyType: String {
    case valueType
    case valueTypeArray
    case objectType
    case objectTypeArray
    case emptyArray
    case nullType
}

/// 支持自动映射的类型
enum VariableType: String {
    case string = "String"
    case int = "Int"
    case float = "Float"
    case double = "Double"
    case bool = "Bool"
    case array = "[]"
    case object = "{OBJ}"
    case null = "Any"
    
    /// Extensive value types with differentiation between the number types.
    init(with JSON: JSON) {
        switch JSON.type {
        case .string:
            self = .string
        case .bool:
            self = .bool
        case .array:
            self = .array
        case .number:
            switch CFNumberGetType(JSON.numberValue as CFNumber) {
            case .sInt8Type,
                 .sInt16Type,
                 .sInt32Type,
                 .sInt64Type,
                 .charType,
                 .shortType,
                 .intType,
                 .longType,
                 .longLongType,
                 .cfIndexType,
                 .nsIntegerType:
                self = .int
            case .float32Type,
                 .float64Type,
                 .floatType,
                 .cgFloatType,
                 .doubleType:
                self = .float
                // Covers any future types for CFNumber.
            @unknown default:
                self = .float
            }
        case .null:
            self = .null
        default:
            self = .object
        }
    }
    
    /// 类型对应的默认值
    var defaultValue: String {
        switch self {
        case .string:
            return "= \"\""
        case .int:
            return "= 0"
        case .float:
            return "= 0.0"
        case .double:
            return "= 0.0"
        case .bool:
            return "= true"
        case .array:
            return "= []"
        case .object:
            return "= OBJ()"
        case .null:
            return ""
        }
    }
}
