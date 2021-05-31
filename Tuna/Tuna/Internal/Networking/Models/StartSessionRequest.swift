//
//  StartSessionRequest.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation

struct StartSessionRequest: Encodable {
    
    struct Customer: Encodable {
        let id: String
        let email: String
        
        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case email = "Email"
        }
    }
    
    let customer: Customer
    
}
