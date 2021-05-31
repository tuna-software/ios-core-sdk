//
//  BindRequest.swift
//  Tuna
//
//  Created by Guilherme Rambo on 04/05/21.
//

import Foundation

struct BindRequest: Encodable {
    let sessionId: String
    let CVV: String
    let token: String
}
