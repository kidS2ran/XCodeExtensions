//
//  GXESnipetCodeService.swift
//  XCodeExtensions
//
//  Created by Son Pham on 10/09/2024.
//

import Foundation

final class GXESnipetCodeService:GXECodeGenService{
    
    enum GenCodeType: CaseIterable{
        case json
        case unitTest
        case ViewModel
        case unkowned
        
        var keyword:[String]{
            switch self {
            case .json:
                return ["json"]
            case .unitTest:
                return ["unitTest","unittest","UNITTEST","unit test"]
            case .ViewModel:
                return ["ViewModel","viewmodel","view model"]
            case .unkowned:
                return []
            }
        }
    }
    
    func getResponse(for prompt: String, with rules: String, completion: @escaping (Result<String, Error>) -> Void) {
        var type: GenCodeType = .json
//        for _type in GenCodeType.allCases{
//            if _type.keyword.contains(where: { prompt.ranges(of: $0).count > 0}){
//                type = _type
//                break
//            }
//        }
        switch type {
        case .json:
            if let jsonData = prompt.data(using: .utf8) {
                do {
                    // Bước 2: Sử dụng JSONSerialization để chuyển đổi từ Data thành dictionary
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        // jsonObject bây giờ là một dictionary [String: Any]
                        print(jsonObject)
                        let finalText = self.generateModelFromJson(jsonObject: jsonObject)
                        completion(.success(finalText))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        case .unitTest:
            completion(.success("Tao unit test thanh cong"))
        case .ViewModel:
            completion(.success("Tao view model thanh cong"))
        case .unkowned:
            completion(.success("Không detect được keyword"))
        }
    }
}

extension GXESnipetCodeService{
    private func generateModelFromJson(jsonObject: Any, modelName: String = "Root") -> String {
        var modelProperties = ""
        var nestedModels = ""
        var mappableProperties = ""
        
        if let dictionary = jsonObject as? [String: Any] {
            for (key, value) in dictionary {
                let propertyType = swiftType(for: value, key: key)
                modelProperties += "    let \(key.replacingOccurrences(of: "_", with: "")): \(propertyType)\n"
                mappableProperties += "\t\(key.replacingOccurrences(of: "_", with: ""))<- map[\"\(key)\"]\n"
                if let nestedDict = value as? [String: Any] {
                    let nestedModel = generateModelFromJson(jsonObject: nestedDict, modelName: capitalizeFirstLetter(key))
                    nestedModels += nestedModel + "\n"
                }
            }
        }
        
        // Tạo mã Swift cho model hiện tại
        let modelCode = """
        struct \(modelName): Mappable {
        \(modelProperties)
            required init?(map: Map) {}
            func mapping(map: Map) {
            \(mappableProperties)
            }
        }
        """
        
        return nestedModels + modelCode
    }

    private func swiftType(for value: Any, key: String) -> String {
        switch value {
        case is String:
            return "String"
        case is Int:
            return "Int"
        case is Double:
            return "Double"
        case is Bool:
            return "Bool"
        case is [Any]:
            return "[Any]"
        case is [String: Any]:
            return capitalizeFirstLetter(key)
        default:
            return "Any"
        }
    }

    private func capitalizeFirstLetter(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
