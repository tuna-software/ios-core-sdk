//
//  SessionIDRequest.swift
//  Tuna
//
//  Created by Guilherme Rambo on 30/03/21.
//

import Foundation

struct SessionIDRequest: Encodable {
    let sessionID: String
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "SessionId"
    }
}
