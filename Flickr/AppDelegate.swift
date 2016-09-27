//
//  AppDelegate.swift
//  Flickr
//
//  Created by Tancrède on 9/22/16.
//  Copyright © 2016 Tancrede. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        var cache = FlkrCache.defaultCache()
        cache.initCache()
        
        
        return true
    }


}

