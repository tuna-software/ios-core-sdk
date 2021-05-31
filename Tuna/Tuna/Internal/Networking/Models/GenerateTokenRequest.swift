//
//  GenerateTokenRequest.swift
//  Tuna
//
//  Created by Guilherme Rambo on 08/04/21.
//

import Foundation

struct GenerateTokenRequest: Encodable {
    struct Card: Encodable {
        let cardNumber: String
        let cardHolderName: String
        let expirationMonth: Int
        let expirationYear: Int
        let cvv: String?
        let singleUse: Bool
    }
    
    let sessionId: String
    let card: Card
}
