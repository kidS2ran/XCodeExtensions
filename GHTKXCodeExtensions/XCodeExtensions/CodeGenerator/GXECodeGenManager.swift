//
//  GXECodeGenManager.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation

class GXECodeGenManager: GXECodeGenService {
    static let shared = GXECodeGenManager()
    
    var codeGenService: GXECodeGenService?
    
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, any Error>) -> Void) {
        codeGenService?.getResponse(for: prompt, with: rules, completion: completion)
    }
}
