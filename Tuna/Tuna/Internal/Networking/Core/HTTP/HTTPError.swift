//
//  HTTPError.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

typealias HTTPResult = Result<HTTPResponse, HTTPError>

struct HTTPError: Error {
    let apiError: TunaAPIError?
    let request: HTTPRequest
    let response: HTTPResponse?
    let underlyingError: Error?
}

struct TunaError: LocalizedError {
    var localizedDescription: String
}

extension HTTPError {
    init(request: HTTPRequest, response: HTTPResponse? = nil, tunaError: TunaError) {
        self.init(apiError: nil, request: request, response: response, underlyingError: tunaError)
    }
}
