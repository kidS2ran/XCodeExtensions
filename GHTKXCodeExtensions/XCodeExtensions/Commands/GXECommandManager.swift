//
//  GXECommandManager.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation

class GXECommandManager{
    private(set) var commands = [String: GXECustomCommandService]()
    
    static let shared = GXECommandManager()
    private init() {}
    
    ///Store Commands custom setup
    func add(commandService: GXECustomCommandService, forType type: GXECommandType) {
        self.commands[type.rawValue] = commandService
    }
    
    //Get
    func getResult(forCommandType type:GXECommandType,
                   selectedText: String,
                   completionHandler: @escaping (Result<String, any Error>) -> Void) {
        
        guard let service = commands[type.rawValue] else {
            completionHandler(.failure(CustomError.networkError))
            return
        }
        
        service.getResultForTheCommand(selectedText: selectedText,
                                       completionHandler: completionHandler)
        
    }
}
