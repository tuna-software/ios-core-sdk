//
//  HTTPMethod.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

struct HTTPMethod: RawRepresentable {
    typealias RawValue = String
    let rawValue: String
}

extension HTTPMethod {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")
    static let put = HTTPMethod(rawValue: "PUT")
    static let patch = HTTPMethod(rawValue: "PATCH")
    static let delete = HTTPMethod(rawValue: "DELETE")
    static let head = HTTPMethod(rawValue: "HEAD")
    static let options = HTTPMethod(rawValue: "OPTIONS")
}

extension HTTPMethod: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { rawValue }
    var description: String { debugDescription }
}
