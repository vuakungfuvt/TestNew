//
//  AppDelegate.swift
//  TestNews
//
//  Created by Phan Xi Phang on 8/12/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let mainVC = MainNewsViewController.create()
        let mainNavigationVC = UINavigationController(rootViewController: mainVC)
        self.window?.rootViewController = mainNavigationVC
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true
        
        return true
    }

}

