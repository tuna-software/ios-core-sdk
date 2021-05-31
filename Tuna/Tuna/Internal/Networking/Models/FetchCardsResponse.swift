//
//  FetchCardsResponse.swift
//  Tuna
//
//  Created by Guilherme Rambo on 30/03/21.
//

import Foundation

struct FetchCardsResponse: Decodable {
    let tokens: [TunaCard]?
}
