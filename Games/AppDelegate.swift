//
//  AppDelegate.swift
//  Games
//
//  Created by Jo Albright on 2/3/16.
//  Copyright © 2016 Jo Albright. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor(white: 1, alpha: 0.1)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.foregroundColor : UIColor.darkGray ]
        UINavigationBar.appearance().tintColor = .lightGray

    }

}

