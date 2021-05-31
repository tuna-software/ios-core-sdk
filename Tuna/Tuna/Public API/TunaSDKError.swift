//
//  TunaSDKError.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation

@objc enum TunaSDKErrorCode: Int {
    case sessionFailedToStart
    case sessionNotStarted
    case failedToFetchCards
    case failedToBindCard
}

@objcMembers public final class TunaSDKError: NSError {
    
    convenience init(apiError: TunaAPIError) {
        self.init(
            domain: kTunaCoreDomain,
            code: apiError.code.rawValue,
            userInfo: [
                NSLocalizedFailureReasonErrorKey: apiError.message
            ]
        )
    }
    
    convenience init(code: TunaSDKErrorCode, underlyingError: Error?, recoverySuggestion: String? = nil) {
        self.init(
            domain: kTunaCoreDomain,
            code: code.rawValue,
            userInfo: [
                NSLocalizedFailureReasonErrorKey: underlyingError?.localizedDescription ?? "",
                NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? ""
            ]
        )
    }
    
}


