//
//  HTTPBody.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

protocol HTTPBody {
    var contentType: String? { get }
    func encode() throws -> Data
    var isEmpty: Bool { get }
}

extension HTTPBody {
    var contentType: String? { nil }
}

struct EmptyHTTPBody: HTTPBody {
    var isEmpty: Bool { true }
    
    func encode() throws -> Data { Data() }
}

struct RawHTTPBody: HTTPBody {
    let contents: Data
    func encode() throws -> Data { contents }
    var isEmpty: Bool { contents.isEmpty }
}

struct JSONHTTPBody: HTTPBody {
    
    var contentType: String? { "application/json; charset=utf-8" }
    
    private let performEncode: () throws -> Data
    
    init<T: Encodable>(_ entity: T, encoder: JSONEncoder = JSONEncoder()) {
        self.performEncode = { try encoder.encode(entity) }
    }
    
    func encode() throws -> Data { try performEncode() }
    
    var isEmpty: Bool { false }
    
}
