//
//  TunaSDK.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation
import os.log

extension URL {
    static let tunaProductionURL = URL(string: "https://token.tunagateway.com")!
    static let tunaSandboxURL = URL(string: "https://token.tuna-demo.uy")!
}

@objcMembers public final class TunaSDK: NSObject {
    
    private let log = OSLog(subsystem: kTunaCoreDomain, category: String(describing: TunaSDK.self))
    
    public static let shared = TunaSDK()
    
    lazy var tokenClient = TokenAPIClient()
    
    public private(set) var isSandbox: Bool = false
    
    public internal(set) lazy var sessionManager: TunaSessionManager = {
        TunaSessionManager(client: tokenClient)
    }()
    
    func configure(appToken: String, sandbox: Bool = false) {
        _appToken = appToken
        
        _tokenAPIBaseURL = sandbox ? .tunaSandboxURL : .tunaProductionURL
        isSandbox = sandbox
    }
    
    private var _tokenAPIBaseURL = URL.tunaSandboxURL
    private var _appToken: String?
    
    var tokenAPIBaseURL: URL { _tokenAPIBaseURL }

    var appToken: String {
        guard let token = _appToken else {
            assertionFailure("Please call TunaSDK.configure() before performing any operations with the SDK. Check out the documentation for details.")
            os_log("FATAL: You must configure the Tuna SDK by calling TunaSDK.configure() before performing any opeartions with the SDK. Check out the documentation for details.", log: self.log, type: .fault)
            return ""
        }
        
        return token
    }

}

// MARK: - Convenience API

@objc public extension TunaSDK {
    
    static func configure(appToken: String, sandbox: Bool = false) {
        Self.shared.configure(
            appToken: appToken,
            sandbox: sandbox
        )
    }
    
    static func setSessionID(_ sessionID: String) {
        assert(!TunaSDK.shared.isSandbox, "\(#function) must not be used when running in the sandbox environment")
        
        TunaSDK.shared.sessionManager.currentSessionID = sessionID
    }
    
    static func startSession(customerId: String, customerEmail: String, completion: ((TunaSDKError?) -> Void)? = nil) {
        assert(TunaSDK.shared.isSandbox, "\(#function) can only be used when running in the sandbox environment. You must use setSessionID() in production.")
        
        TunaSDK.shared.sessionManager.startSession(
            customerId: customerId,
            customerEmail: customerEmail,
            completion: completion
        )
    }
    
    @nonobjc static func fetchCards(with completion: @escaping (Swift.Result<[TunaCard], TunaSDKError>) -> Void) {
        TunaSDK.shared.sessionManager.fetchCards(with: completion)
    }
    
    @available(swift, obsoleted: 1.0, message: "This method is provided for Objective-C compatibility only, please use the Swift version instead.")
    @objc(fetchCardsWithCompletionHandler:)
    static func fetchCards(_ completion: @escaping ([TunaCard]?, TunaSDKError?) -> Void) {
        TunaSDK.shared.sessionManager.fetchCards { result in
            switch result {
            case .success(let cards):
                completion(cards, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    @nonobjc static func addNewCard(number: String, cardHolderName: String, expirationMonth: Int, expirationYear: Int, cvv: String? = nil, save: Bool = true, completion: @escaping (Result<TunaCard, TunaSDKError>) -> Void) {
        TunaSDK.shared.sessionManager.addCard(
            holderName: cardHolderName,
            number: number,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            cvv: cvv,
            save: save,
            completion: completion
        )
    }
    
    @available(swift, obsoleted: 1.0, message: "This method is provided for Objective-C compatibility only, please use the Swift version instead.")
    @objc static func addNewCard(withNumber number: String, cardHolderName: String, expirationMonth: NSNumber, expirationYear: NSNumber, cvv: String?, save: Bool, completion: @escaping (TunaCard?, TunaSDKError?) -> Void) {
        TunaSDK.shared.sessionManager.addCard(
            holderName: cardHolderName,
            number: number,
            expirationMonth: expirationMonth.intValue,
            expirationYear: expirationYear.intValue,
            cvv: cvv,
            save: save
        ) { result in
            switch result {
            case .success(let card):
                completion(card, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    @nonobjc static func bindCard(_ card: TunaCard, cvv: String, completion: @escaping (Result<TunaCard, TunaSDKError>) -> Void) {
        TunaSDK.shared.sessionManager.bind(card, cvv: cvv, completion: completion)
    }
    
    @available(swift, obsoleted: 1.0, message: "This method is provided for Objective-C compatibility only, please use the Swift version instead.")
    static func bindCard(_ card: TunaCard, cvv: String, completion: @escaping (TunaCard?, TunaSDKError?) -> Void) {
        TunaSDK.shared.sessionManager.bind(card, cvv: cvv) { result in
            switch result {
            case .success(let card):
                completion(card, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
