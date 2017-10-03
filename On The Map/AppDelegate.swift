//
//  AppDelegate.swift
//  On The Map
//
//  Created by Sören Kirchner on 08.09.17.
//  Copyright © 2017 Sören Kirchner. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String:AnyObject]
typealias JSONArray = [JSONDictionary]
typealias ParametersArray = [String:AnyObject]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

}

