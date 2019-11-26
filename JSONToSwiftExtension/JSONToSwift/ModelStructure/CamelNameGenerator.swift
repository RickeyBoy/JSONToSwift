//
//  CamelNameGenerator.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/22.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation

struct CamelNameGenerator {
    /// 驼峰命名
    static func camelName(raw: String) -> String {
        let rawSubs = raw.components(separatedBy: CharacterSet(charactersIn: "-_ "))
        var camelSubs: [String] = []
        for (index, sub) in rawSubs.enumerated() {
            if index == 0 { camelSubs.append(sub) }
            else if sub.count == 0 { continue }
            else {
                camelSubs.append(sub.prefix(1).uppercased() + sub.lowercased().dropFirst())
            }
        }
        return camelSubs.reduce("", +)
    }
}
