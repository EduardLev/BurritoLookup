//
//  AppDelegate.swift
//  BurritoLookup
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let googleSDKApiKey = "AIzaSyAfnzuqwz2x7xMHp-qqRVsxoCLaPWgL2qk"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        GMSServices.provideAPIKey(AppDelegate.googleSDKApiKey)
        GMSPlacesClient.provideAPIKey(AppDelegate.googleSDKApiKey)

        let burritoListVC = BurritoListTableViewController()
        let burritoMapVC = BurritoMapViewController()
        let navigationController = UINavigationController(rootViewController: burritoListVC)
        let splitViewController = GlobalSplitViewController()
        splitViewController.viewControllers = [navigationController, burritoMapVC]
        window?.rootViewController = splitViewController

        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }
}
