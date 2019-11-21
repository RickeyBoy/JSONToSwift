//
//  ObjectMapperSnippet.swift
//  RExtension
//
//  Created by Rickey on 2019/11/14.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation

struct ObjectMapperSnippet {
    
    static func getClassSnippet(file: ModelFile) -> String {
        let top = topSnippet(name: file.fileName)
        let varis = file.component.list.reduce("", { (result, item) -> String in
            return "\(result)\n\(ObjectMapperSnippet.varSnippet(key: item.name, type: item.type))"
        })
        let maps = file.component.list.reduce("", { (result, item) -> String in
            return "\(result)\n\(ObjectMapperSnippet.mapSnippet(key: item.name))"
        })
        return [top, varis, midSnippet, maps, bottomSnippet].reduce("", +)
    }
    
    /// 头部固定代码
    static func topSnippet(name: String) -> String {
        // TODO: - 之后加上相关的 init value
        return "class \(name): Mappable {\n"
    }
    
    /// 中部固定代码
    static let midSnippet = "\n\n    open func mapping(map: Map) {"
    
    /// 底部固定代码
    static let bottomSnippet =
"""

    }

    required convenience public init?(map: Map) {
        self.init()
    }
    public init() {}

}
"""
    
    /// 获取变量行代码
    static func varSnippet(key: String, type: String) -> String {
        // TODO: - 之后加上相关的 init value
        return "    var \(key): \(type)"
    }
        
    /// 获取 map 行代码
    static func mapSnippet(key: String) -> String {
        return "        \(key) <- map[\"\(key)\"]"
    }
}
