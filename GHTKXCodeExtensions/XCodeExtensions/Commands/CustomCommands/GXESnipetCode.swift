//
//  GXESnipetCode.swift
//  XCodeExtensions
//
//  Created by Son Pham on 12/09/2024.
//

import Foundation

class GXESnipetCode: GXECustomCommandService{
    var rules: String = """
    snipet code create by Cucai
    """
    
    private var snipetService = GXESnipetCodeService()
    
    func getResultForTheCommand(selectedText: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        self.snipetService.getResponse(for: selectedText,
                                       with: rules) { result in
            switch result {
            case .success(let message):
                completionHandler(.success(message))
                return
            case .failure(let error):
                completionHandler(.failure(error))
                return
            }
        }
    }
}
