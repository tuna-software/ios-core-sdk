//
//  TunaSessionManager.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation
import os.log

@objcMembers public final class TunaSessionManager: NSObject {
    
    private let log = OSLog.tunaCoreLog(for: String(describing: TunaSessionManager.self))
    
    private let client: TokenAPIClient
    
    init(client: TokenAPIClient) {
        self.client = client
    }
    
    var currentSessionID: String? {
        didSet {
            guard currentSessionID != oldValue, let id = currentSessionID else { return }
            os_log("New session id is %@", log: self.log, type: .debug, id)
        }
    }
    
    public func startSession(customerId: String, customerEmail: String, completion: ((TunaSDKError?) -> Void)? = nil) {
        os_log("%{public}@", log: log, type: .debug, #function)
        
        let body = JSONHTTPBody(
            StartSessionRequest(
                customer: StartSessionRequest.Customer(
                    id: customerId,
                    email: customerEmail
                )
            )
        )
        
        let request = HTTPRequest(
            url: TunaSDK.shared.tokenAPIBaseURL.appendingPathComponent("/api/Token/NewSession"),
            method: .post,
            headers: ["x-tuna-apptoken": TunaSDK.shared.appToken],
            body: body
        )
        
        client.performRequest(request, responseType: StartSessionResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                os_log("Failed to start a new session: %{public}@", log: self.log, type: .debug, String(describing: error))
                
                DispatchQueue.main.async {
                    completion?(TunaSDKError(code: .sessionFailedToStart, underlyingError: error))
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.currentSessionID = response.sessionId
                    
                    completion?(nil)
                }
            }
        }
    }
    
    public func fetchCards(with completion: @escaping (Swift.Result<[TunaCard], TunaSDKError>) -> Void) {
        os_log("%{public}@", log: log, type: .debug, #function)
        
        guard let sessionID = currentSessionID else {
            completion(.failure(TunaSDKError(code: .sessionNotStarted, underlyingError: nil)))
            return
        }
        
        let body = JSONHTTPBody(
            SessionIDRequest(sessionID: sessionID)
        )
        
        let request = HTTPRequest(
            url: TunaSDK.shared.tokenAPIBaseURL.appendingPathComponent("/api/Token/List"),
            method: .post,
            headers: [:],
            body: body
        )
        
        client.performRequest(request, responseType: FetchCardsResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                os_log("Failed to fetch cards: %{public}@", log: self.log, type: .debug, String(describing: error))

                DispatchQueue.main.async {
                    if let apiError = error.apiError {
                        completion(.failure(TunaSDKError(apiError: apiError)))
                    } else {
                        completion(.failure(TunaSDKError(code: .failedToFetchCards, underlyingError: error)))
                    }
                }
            case .success(let response):
                DispatchQueue.main.async {
                    let responseTokens: [TunaCard] = response.tokens ?? []
                    completion(.success(responseTokens))
                }
            }
        }
    }
    
    public func addCard(holderName: String, number: String, expirationMonth: Int, expirationYear: Int, cvv: String? = nil, save: Bool, completion: @escaping (Swift.Result<TunaCard, TunaSDKError>) -> Void) {
        os_log("%{public}@", log: log, type: .debug, #function)
        
        guard let sessionID = currentSessionID else {
            completion(.failure(TunaSDKError(code: .sessionNotStarted, underlyingError: nil)))
            return
        }
        
        let body = JSONHTTPBody(
            GenerateTokenRequest(
                sessionId: sessionID,
                card: GenerateTokenRequest.Card(
                    cardNumber: number,
                    cardHolderName: holderName,
                    expirationMonth: expirationMonth,
                    expirationYear: expirationYear,
                    cvv: cvv,
                    singleUse: !save
                )
            )
        )
        
        let request = HTTPRequest(
            url: TunaSDK.shared.tokenAPIBaseURL.appendingPathComponent("/api/Token/Generate"),
            method: .post,
            headers: [:],
            body: body
        )
        
        client.performRequest(request, responseType: GenerateTokenResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                os_log("Failed to fetch cards: %{public}@", log: self.log, type: .debug, String(describing: error))

                DispatchQueue.main.async {
                    if let apiError = error.apiError {
                        completion(.failure(TunaSDKError(apiError: apiError)))
                    } else {
                        completion(.failure(TunaSDKError(code: .failedToFetchCards, underlyingError: error)))
                    }
                }
            case .success(let response):
                DispatchQueue.main.async {
                    let newCard = TunaCard(
                        token: response.token,
                        brand: response.brand,
                        cardHolderName: holderName,
                        expirationMonth: expirationMonth,
                        expirationYear: expirationYear,
                        maskedNumber: number,
                        singleUse: !save
                    )
                    
                    completion(.success(newCard))
                }
            }
        }
    }
    
    public func bind(_ card: TunaCard, cvv: String, completion: @escaping (Swift.Result<TunaCard, TunaSDKError>) -> Void    ) {
        os_log("%{public}@", log: log, type: .debug, #function)
        
        guard let sessionID = currentSessionID else {
            completion(.failure(TunaSDKError(code: .sessionNotStarted, underlyingError: nil)))
            return
        }
        
        let body = JSONHTTPBody(
            BindRequest(
                sessionId: sessionID,
                CVV: cvv,
                token: card.token
            )
        )
        
        let request = HTTPRequest(
            url: TunaSDK.shared.tokenAPIBaseURL.appendingPathComponent("/api/Token/Bind"),
            method: .post,
            headers: [:],
            body: body
        )
        
        client.performRequest(request, responseType: BindResponse.self) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                os_log("Failed to bind card: %{public}@", log: self.log, type: .debug, String(describing: error))

                DispatchQueue.main.async {
                    if let apiError = error.apiError {
                        completion(.failure(TunaSDKError(apiError: apiError)))
                    } else {
                        completion(.failure(TunaSDKError(code: .failedToBindCard, underlyingError: error)))
                    }
                }
            case .success(let response):
                os_log("Bind card response: %@", log: self.log, type: .debug, String(describing: response))
                
                DispatchQueue.main.async {
                    completion(.success(card))
                }
            }
        }
    }
    
}
