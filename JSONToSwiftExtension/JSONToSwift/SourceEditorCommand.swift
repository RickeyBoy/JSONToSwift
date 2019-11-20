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
        var content = SourceEditorUtil.selectedContent(buffer: invocation.buffer)
        if content.count <= 0 {
            content = SourceEditorUtil.fileContent(buffer: invocation.buffer)
        }
        guard content.count > 0 else {
            let error = NSError(domain: "No Json Data Selected", code: 1, userInfo: nil)
            completionHandler(error)
            return
        }
        
        // Json Serialization
        var json: [String: Any] = [:]
        do {
            let jsonData = try JSONSerialization.jsonObject(with: content.data(using: .utf8)!, options : .allowFragments)
            if let jsonData = jsonData as? [String: Any] {
                json = jsonData
            }
        } catch let error as NSError {
            completionHandler(error)
            return
        }
        let sJSON = JSON(parseJSON: content)
        let generator = ModelGenerator()
        let modelFile = generator.generateModelForJSON(sJSON, "testClass", true)
        
        // Inset snippets
        let headIndex = SourceEditorUtil.insertLineIndex(buffer: invocation.buffer)
        guard headIndex >= 1 else {
            let error = NSError(domain: "Invalid lines count", code: 2, userInfo: nil)
            completionHandler(error)
            return
        }
//        invocation.buffer.lines.insert(ObjectMapperSnippet.getClassSnippet(keys: Array(json.keys)), at: headIndex)
        invocation.buffer.lines.insert(ObjectMapperSnippet.getClassSnippet(file: modelFile[0]), at: headIndex)
        completionHandler(nil)
    }
    
}
