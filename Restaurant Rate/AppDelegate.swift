//
//  AppDelegate.swift
//  Restaurant Rate
//
//  Created by Tigran Oganisyan on 24.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
        } else {
            let viewController = MainViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            self.window = UIWindow()
            self.window!.rootViewController = navigationController
            self.window!.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

