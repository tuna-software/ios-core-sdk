//
//  HTTPStatus.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

struct HTTPStatus: RawRepresentable {
    typealias RawValue = Int
    let rawValue: Int
}

extension HTTPStatus {
    
    static let success = HTTPStatus(rawValue: 200)

    static let notModified = HTTPStatus(rawValue: 304)

    static let badRequest = HTTPStatus(rawValue: 400)
    static let unauthorized = HTTPStatus(rawValue: 401)
    static let forbidden = HTTPStatus(rawValue: 403)
    static let notFound = HTTPStatus(rawValue: 404)
    
    static let internalServerError = HTTPStatus(rawValue: 500)
    static let badGateway = HTTPStatus(rawValue: 502)
    static let serviceUnavailable = HTTPStatus(rawValue: 503)
    static let gatewayTimeout = HTTPStatus(rawValue: 504)
    
}

extension HTTPStatus: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String { String(rawValue) }
    var description: String { debugDescription }
}
