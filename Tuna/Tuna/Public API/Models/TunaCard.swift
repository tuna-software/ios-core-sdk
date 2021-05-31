//
//  TunaCard.swift
//  Tuna
//
//  Created by Guilherme Rambo on 30/03/21.
//

import Foundation

@objcMembers public final class TunaCard: NSObject, Decodable {

    public let token: String
    public let brand: String
    public let cardHolderName: String
    public let expirationMonth: Int
    public let expirationYear: Int
    public let maskedNumber: String
    public let singleUse: Bool
    
    init(token: String, brand: String, cardHolderName: String, expirationMonth: Int, expirationYear: Int, maskedNumber: String, singleUse: Bool) {
        self.token = token
        self.brand = brand
        self.cardHolderName = cardHolderName
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.maskedNumber = maskedNumber
        self.singleUse = singleUse
    }

}
