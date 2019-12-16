//
//  JSONComponent.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/15.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation

/// 模型中的一个变量
struct PropertyComponent {
    var name: String
    var type: String
    var defaultValue: String
    var key: String
    var propertyType: PropertyType
    
    init(_ name: String, _ type: String, _ defaultValue: String, _ key: String, _ propertyType: PropertyType) {
        self.name = name
        self.type = type
        self.defaultValue = defaultValue
        self.key = key
        self.propertyType = propertyType
    }
}
