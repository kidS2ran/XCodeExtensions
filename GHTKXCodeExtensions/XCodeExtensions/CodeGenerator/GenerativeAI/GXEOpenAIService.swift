//
//  GXEOpenAIService.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation
import OpenAISwift

final class GXEOpenAIService: GXECodeGenService {
    private 
    var client: OpenAISwift?
    private
    var key = ""
    
    init(){
        self.setup()
    }
    
    func setup() {
        // Don't commit API key
        let config = OpenAISwift.Config.makeDefaultOpenAI(apiKey: key)
        client = OpenAISwift(config: config)
    }
    
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, any Error>) -> Void) {
        let prompt: ChatMessage = ChatMessage(role: .assistant,
                                              content: "\(rules) \n\n \(prompt)")
        
        client?.sendChat(with: [prompt],
                         maxTokens: 500,
                         completionHandler: { result in
            switch result {
            case .success(let message):
                let output = message.choices?.first?.message.content ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
