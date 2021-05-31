//
//  HTTPRequest.swift
//  Tuna
//
//  Created by Guilherme Rambo on 19/03/21.
//

import Foundation

struct HTTPRequest {
    private var components = URLComponents()
    var method: HTTPMethod = .get
    var headers: [String: String] = [:]
    var body: HTTPBody

    init(url: URL, method: HTTPMethod = .get, headers: [String: String] = [:], body: HTTPBody = EmptyHTTPBody()) {
        self.components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    var url: URL? { components.url }
}

extension HTTPRequest {
    
    var scheme: String { components.scheme ?? "https" }
    
    var host: String? {
        get { components.host }
        set { components.host = newValue }
    }
    
    var path: String {
        get { components.path }
        set { components.path = newValue }
    }
    
}

extension HTTPRequest: CustomDebugStringConvertible, CustomStringConvertible {
    
    var debugDescription: String { "\(method.rawValue) \(components.path)" }
    
    var description: String { debugDescription }
    
}
