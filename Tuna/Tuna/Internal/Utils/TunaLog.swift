//
//  TunaLog.swift
//  Tuna
//
//  Created by Guilherme Rambo on 24/03/21.
//

import Foundation
import os.log

let kTunaCoreDomain = "uy.tuna.core"

extension OSLog {
    static func tunaCoreLog(for category: String) -> OSLog {
        OSLog(subsystem: kTunaCoreDomain, category: category)
    }
}
