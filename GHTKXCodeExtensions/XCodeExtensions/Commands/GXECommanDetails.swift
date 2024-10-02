//
//  CommanDetails.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation
import XcodeKit

enum GXECommandType: String {
    case snipetCode = "SnipetCode"
    case generateCode = "GenerateCode"
    case writeUnitTests = "WriteUnitTests"
    case unknown = "Unknown"
    
    static func getCommand(forIdentifier identifier: String) -> GXECommandType {
        switch identifier {
        case GXECommandType.snipetCode.rawValue:
            return .snipetCode
        case GXECommandType.generateCode.rawValue:
            return .generateCode
        case GXECommandType.writeUnitTests.rawValue:
            return .writeUnitTests
        default:
            return .unknown
        }
    }
}

struct GXECommandDetails{
    var identifier: String
    var selectedText: String
    var selection: XCSourceTextRange
    var source: XCSourceTextBuffer
    
    static func getDetails(from invocation: XCSourceEditorCommandInvocation) -> GXECommandDetails? {
        guard let selectedText = GXETextSelection.getSelectedText(source: invocation.buffer) else {
            return nil
        }
        let source = invocation.buffer
        guard let selection = source.selections.firstObject as? XCSourceTextRange, selection.start.line < source.lines.count else {
            return nil
        }
        return GXECommandDetails(identifier: invocation.commandIdentifier,
                                selectedText: selectedText,
                                selection: selection,
                                source: invocation.buffer)
    }
}
