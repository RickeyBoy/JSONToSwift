//
//  SourceEditorCommand.swift
//  JSONToSwift
//
//  Created by Rickey on 2019/11/15.
//  Copyright © 2019 Rickey Wang. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.

        // Read selection content
        let content = Preprocessor.selectedContent(buffer: invocation.buffer)
        guard content.jsonStr.count > 0 else {
            let error = NSError(domain: "No Json Data Selected", code: 1, userInfo: nil)
            completionHandler(error)
            return
        }
        
        // Json Serialization
        let sJSON = JSON(parseJSON: content.jsonStr)
        let generator = ModelGenerator()
        let modelFile = generator.generateModelForJSON(sJSON, "SampleName", true)
        
        // Inset snippets
        let headIndex = SourceEditorUtil.insertLineIndex(buffer: invocation.buffer)
        guard headIndex >= 1 else {
            let error = NSError(domain: "Invalid lines count", code: 2, userInfo: nil)
            completionHandler(error)
            return
        }
        let snippets = modelFile.map { ObjectMapperSnippet.getClassSnippet(file: $0) }
        let output = snippets.reduce("") { (result, item) -> String in
            return result + "\n" + item
        }
        invocation.buffer.lines.insert(output, at: headIndex)
        completionHandler(nil)
    }
    
}
