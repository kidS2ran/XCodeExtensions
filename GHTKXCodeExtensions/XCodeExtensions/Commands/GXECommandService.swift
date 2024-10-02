//
//  CommandService.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation

enum CustomError: Error {
    case invalidSelection
    case networkError
    case databaseError
    // Add more cases as needed
}

protocol GXECustomCommandService {
    var rules: String { get }
    
    func getResultForTheCommand(selectedText: String, completionHandler: @escaping (Result<String, Error>) -> Void)
}
