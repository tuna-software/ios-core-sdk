//
//  HTTPLoading.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation
import os.log

protocol HTTPLoading: AnyObject {
    func load(_ request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}

extension URLSession: HTTPLoading {
    
    static let log = OSLog.tunaCoreLog(for: "URLSession+HTTPLoading")
    
    func load(_ request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        guard let url = request.url else {
            os_log("Failed to generate URL for request %@", log: Self.log, type: .fault, request.debugDescription)
            completion(.failure(.init(request: request, tunaError: TunaError(localizedDescription: "Invalid request."))))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        if !request.body.isEmpty {
            if let contentType = request.body.contentType {
                urlRequest.addValue(contentType, forHTTPHeaderField: "content-type")
            }
    
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                os_log("Failed to encode request body for request %@: %{public}@", log: Self.log, type: .error, request.debugDescription, String(describing: error))
                completion(.failure(.init(request: request, tunaError: TunaError(localizedDescription: "Failed to encode request body: \(error)."))))
            }
        }
        
        let task = dataTask(with: urlRequest) { data, response, error in
            var httpResponse: HTTPResponse?
            
            if let res = response as? HTTPURLResponse {
                httpResponse = HTTPResponse(
                    request: request,
                    response: res,
                    body: data ?? Data()
                )
            }

            if let error = error {
                completion(.failure(
                    HTTPError(
                        apiError: nil,
                        request: request,
                        response: httpResponse,
                        underlyingError: error
                    )
                ))
                return
            }
            
            if let response = httpResponse {
                completion(.success(response))
            } else {
                completion(.failure(.init(request: request, response: nil, tunaError: TunaError(localizedDescription: "No response."))))
            }
        }
        
        task.resume()
    }
    
}
