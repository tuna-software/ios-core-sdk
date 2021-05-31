//
//  TokenAPIClient.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation

final class TokenAPIClient {
    
    let loader: HTTPLoading
    
    init(loader: HTTPLoading = URLSession.shared) {
        self.loader = loader
    }
    
    func performRequest<R: Decodable>(_ request: HTTPRequest, responseType: R.Type, completion: @escaping (Result<R, HTTPError>) -> Void) {
        loader.load(request) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromPascalCase
                    
                    let decodedBody = try decoder.decode(R.self, from: response.body)
                    
                    completion(.success(decodedBody))
                } catch {
                    let errorDecoder = JSONDecoder()
                    errorDecoder.keyDecodingStrategy = .convertFromPascalCase
                    
                    do {
                        let decodedError = try errorDecoder.decode(TunaAPIError.self, from: response.body)
                        
                        completion(.failure(.init(apiError: decodedError, request: request, response: response, underlyingError: error)))
                    } catch {
                        completion(.failure(.init(request: request, response: response, tunaError: TunaError(localizedDescription: "Failed to decode response: \(error)."))))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
