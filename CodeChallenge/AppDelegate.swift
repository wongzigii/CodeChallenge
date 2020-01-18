//
//  AppDelegate.swift
//  CodeChallenge
//
//  Created by 智杰 on 2020/1/10.
//  Copyright © 2020 Zigii. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let main = UINavigationController(rootViewController: MainViewController())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = main
        self.window?.makeKeyAndVisible()
        return true
    }
}
