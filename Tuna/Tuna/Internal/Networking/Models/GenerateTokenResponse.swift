//
//  GenerateTokenResponse.swift
//  Tuna
//
//  Created by Guilherme Rambo on 08/04/21.
//

import Foundation

struct GenerateTokenResponse: Decodable {
    let token: String
    let brand: String
    let code: Int
    let message: String?
}
