//
//  SourceEditorCommand.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        setUp()
        print("ImproveMyCode: \(invocation.description)")
        print("ImproveMyCode: \(invocation.commandIdentifier)")
        
        guard let commandDetails = GXECommandDetails.getDetails(from: invocation) else {
            completionHandler(CustomError.networkError)
            return
        }
        
        runCommand(command: commandDetails,
                   completionHandler: completionHandler)
        completionHandler(nil)
    }
    
}

extension SourceEditorCommand{
    /// Initial setup and adding commands
    private func setUp() {
        GXECommandManager.shared.add(commandService: GXESnipetCode(),
                                     forType: .snipetCode)
        GXECommandManager.shared.add(commandService: GXEAIGenerateCode(),
                                     forType: .generateCode)
        GXECommandManager.shared.add(commandService: GXEWriteUnitTests(),
                                     forType: .writeUnitTests)
        GXECodeGenManager.shared.codeGenService = GXEOpenAIService()
    }
}

/// Handle commands
extension SourceEditorCommand {
    private func runCommand(command: GXECommandDetails,
                            completionHandler: @escaping (Error?) -> Void) {

        let type = GXECommandType.getCommand(forIdentifier: command.identifier)

        GXECommandManager.shared.getResult(forCommandType: type,
                                        selectedText: command.selectedText) { result in
            switch result {
            case .success(let message):
                let output = (GXETextSelection.indentation(line: command.source.lines[command.selection.start.line] as! String))
                let finalText = output + "\(message)"

                print("Final text is --\n " + finalText)
                command.source.lines.insert(finalText, at: command.selection.end.line + 1)
                completionHandler(nil)
                return
            case .failure(let error):
                completionHandler(error)
                return
            }
        }
    }
}
