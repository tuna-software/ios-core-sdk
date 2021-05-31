//
//  AppDelegate.swift
//  SDKExampleSwift
//
//  Created by Guilherme Rambo on 24/03/21.
//

import UIKit
import Tuna

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TunaSDK.configure(
            appToken: "YOUR-TOKEN-HERE",
            sandbox: true
        )

        return true
	}
	
}

