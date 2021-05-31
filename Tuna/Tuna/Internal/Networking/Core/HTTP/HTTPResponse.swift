//
//  HTTPResponse.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

struct HTTPResponse {
    let request: HTTPRequest
    private let underlyingResponse: HTTPURLResponse
    var body: Data
    
    var status: HTTPStatus { HTTPStatus(rawValue: underlyingResponse.statusCode) }
    
    var headers: [AnyHashable: Any] { underlyingResponse.allHeaderFields }
    
    init(request: HTTPRequest, response: HTTPURLResponse, body: Data) {
        self.request = request
        self.underlyingResponse = response
        self.body = body
    }
}
