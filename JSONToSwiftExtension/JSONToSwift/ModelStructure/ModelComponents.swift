//
//  ModelComponents.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/18.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

/// 模型中的变量信息
/// A strcture to store the various components of a model file.
internal struct ModelComponents {
    var list: [ModelComponent] = []
}

internal struct ModelComponent {
    /// name
    var name = ""
    /// type
    var type = ""
    /// raw name to map
    var map = ""
    
    init(name: String, type: String, map: String) {
        self.name = name
        self.type = type
        self.map = map
    }
}
