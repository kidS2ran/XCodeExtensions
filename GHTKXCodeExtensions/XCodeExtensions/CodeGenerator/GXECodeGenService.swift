//
//  GXECodeGenService.swift
//  XCodeExtensions
//
//  Created by Son Pham on 05/09/2024.
//

import Foundation

protocol GXECodeGenService {
    func getResponse(for prompt: String,
                     with rules: String,
                     completion: @escaping (Result<String, Error>) -> Void)
}
