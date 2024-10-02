//
//  GXEAIGenerateCode.swift
//  XCodeExtensions
//
//  Created by Son Pham on 10/09/2024.
//

import Foundation

class GXEAIGenerateCode: GXECustomCommandService{
    var rules: String = """
        Sử dụng Chat GPT để tạo ra code
        đang sử dụng tk free giới hạn 5$
    """
    
    func getResultForTheCommand(selectedText: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        GXECodeGenManager.shared.getResponse(for: selectedText,
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
