//
//  AppDelegate.swift
//  MemeMe 1.0
//
//  Created by Kemal Kaynak on 04.06.20.
//  Copyright © 2020 Kemal Kaynak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var updateNotificationName = NSNotification.Name("modelUpdated")
    var memes = [Meme]() {
        didSet {
            // Prefer to use NotificationCenter rather than protocol because it should trigger multiple classes such as SentMemesTableViewController&SentMemesCollectionViewController
            NotificationCenter.default.post(name: updateNotificationName, object: nil)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

