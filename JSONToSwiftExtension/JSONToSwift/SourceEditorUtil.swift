//
//  SourceEditorUtil.swift
//  RExtension
//
//  Created by Rickey on 2019/11/14.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation
import XcodeKit

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

struct SourceEditorUtil {
    
    /// 获取整个文件的代码，过滤注释掉的部分
    static func fileContent(buffer: XCSourceTextBuffer) -> String {
        return buffer.lines.reduce("") { (result, item) -> String in
            if let str = item as? String, !str.hasPrefix("//") {
                return "\(result)\(str)"
            } else {
                return result
            }
        }
    }
    
    /// index to insert snippets
    static func insertLineIndex(buffer: XCSourceTextBuffer) -> Int {
        if let selections = buffer.selections as? [XCSourceTextRange], let last = selections.last {
            // return last selection line
            return last.end.line
        } else {
            // return last line
            return buffer.lines.count
        }
    }
}
