//
//  AppDelegate.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Buglife

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)

        DataHolder.sharedInstance().start()

        Buglife.sharedBuglife().startWithAPIKey("HUJ2TuijE71gbQX10vVMTAtt")
        Buglife.sharedBuglife().invocationOptions = LIFEInvocationOptions.FloatingButton
        //Buglife.sharedBuglife().invocationOptions = LIFEInvocationOptions.Shake
        //Buglife.sharedBuglife().invocationOptions = LIFEInvocationOptions.Screenshot

        Instabug.startWithToken("df211ab7adb397659a475878af6e8ae2", invocationEvent: IBGInvocationEvent.Shake)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate:
        // when the user quits.
        DataHolder.sharedInstance().saveData()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
