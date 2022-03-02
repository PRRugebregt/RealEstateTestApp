//
//  AppDelegate.swift
//  RealEstateDTT
//
//  Created by Patrick Rugebregt on 22/02/2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var houses = [House]()
    var locationManager = LocationManager()
    let network = NetworkDownload()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(updateHouses(_:)), name: .updateHouses, object: nil)
        return true
    }

    // Updating houses to distribute to FavoritesViewController
    @objc func updateHouses(_ notification: Notification) {
        print("received Notification in App Delegate")
        if let houses = notification.userInfo?["houses"] as? [House] {
            self.houses = houses
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

}

