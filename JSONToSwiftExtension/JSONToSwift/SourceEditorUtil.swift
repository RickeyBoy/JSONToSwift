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
    
    /// Get combined string of selection content
    static func selectedContent(buffer: XCSourceTextBuffer) -> String {
        guard let selections = buffer.selections as? [XCSourceTextRange], let lines = buffer.lines as? [String] else { return "" }
        guard let start = selections.first?.start, let end = selections.last?.end else { return "" }
        if start.line == end.line {
            // single line
            let lineText = lines[start.line]
            return lineText[start.column..<end.column-start.column+1]
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
            return results
        }
    }
    
    /// Get combined string of the file, will filter lines with prefix of //
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
