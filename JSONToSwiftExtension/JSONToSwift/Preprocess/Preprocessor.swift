//
//  Preprocessor.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/12/12.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation
import XcodeKit

/// 预处理之后的结果
struct PreprocessModel  {
    
    var jsonStr = ""
    
}

/// 模型预处理
struct Preprocessor {
    
    /// Get combined string of selection content
    static func selectedContent(buffer: XCSourceTextBuffer) -> PreprocessModel {
        var model = PreprocessModel()
        guard let selections = buffer.selections as? [XCSourceTextRange], let lines = buffer.lines as? [String] else { return model }
        guard let start = selections.first?.start, let end = selections.last?.end else { return model }
        if start.line == end.line {
            // single line
            let lineText = lines[start.line]
            model.jsonStr = lineText[start.column..<end.column-start.column+1]
        } else {
            // multiple lines
            var results = ""
            for index in 0..<selections.count {
                let lineText = lines[index]
                if index == start.line {
                    results = lineText[start.column..<lineText.count]
                } else if index == end.line {
                    results = results + lineText[start.column..<lineText.count]
                } else {
                    results = results + lineText
                }
            }
            model.jsonStr = results
        }
        return model
    }
}

