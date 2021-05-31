//
//  PascalCase.swift
//  Tuna
//
//  Created by Guilherme Rambo on 18/03/21.
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy {

    /// Converts keys from `PascalCase` to `camelCase`.
    static let convertFromPascalCase = JSONDecoder.KeyDecodingStrategy.custom { keys in
        let lastComponent = keys.last!.stringValue.lowercasingFirstCharacter
        
        return AnyKey(stringValue: lastComponent)!
    }
    
}

extension JSONEncoder.KeyEncodingStrategy {
    
    /// Converts keys from `camelCase` to `PascalCase`.
    static let convertToPascalCase = JSONEncoder.KeyEncodingStrategy.custom { keys in
        let lastComponent = keys.last!.stringValue.uppercasingFirstCharacter
        
        return AnyKey(stringValue: lastComponent)!
    }
    
}

fileprivate struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

fileprivate extension String {
    var lowercasingFirstCharacter: String {
        return prefix(1).lowercased() + self.dropFirst()
    }
    
    var uppercasingFirstCharacter: String {
        return prefix(1).uppercased() + self.dropFirst()
    }
}
