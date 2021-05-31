//
//  TunaAPIError.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

struct TunaAPIError: Hashable, Decodable {
    struct Code: RawRepresentable, Decodable, Hashable {
        typealias RawValue = Int
        let rawValue: Int
    }
    
    let code: Code
    let message: String
}

extension TunaAPIError.Code {
    static let requestNull = TunaAPIError.Code(rawValue: 100)
    static let sessionInvalid = TunaAPIError.Code(rawValue: 101)
    static let sessionExpired = TunaAPIError.Code(rawValue: 102)
    static let cardDataMissed = TunaAPIError.Code(rawValue: 103)
    static let cardNumberAlreadyTokenized = TunaAPIError.Code(rawValue: 104)
    static let invalidExpirationDate = TunaAPIError.Code(rawValue: 105)
    static let invalidCardNumber = TunaAPIError.Code(rawValue: 106)
    static let tokenNotFound = TunaAPIError.Code(rawValue: 107)
    static let tokenCanNotBeRemoved = TunaAPIError.Code(rawValue: 108)
    static let cardCanNotBeRemoved = TunaAPIError.Code(rawValue: 109)
    static let partnerGuidMissed = TunaAPIError.Code(rawValue: 110)
    static let partnerDoesNotExists = TunaAPIError.Code(rawValue: 111)
    static let invalidPartnerToken = TunaAPIError.Code(rawValue: 112)
    static let customerDataMissed = TunaAPIError.Code(rawValue: 113)
    static let requestTokenMissed = TunaAPIError.Code(rawValue: 114)
    static let invalidCardToken = TunaAPIError.Code(rawValue: 1115)
    static let invalidCardHolderName = TunaAPIError.Code(rawValue: 116)
    static let reachedMaxCardsByUser = TunaAPIError.Code(rawValue: 117)
}
