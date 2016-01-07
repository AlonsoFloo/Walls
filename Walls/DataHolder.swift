//
//  DataHolder.swift
//  Walls
//
//  Created by Inès MARTIN on 04/01/2016.
//  Copyright © 2016 EPSI. All rights reserved.
//

import Foundation

class DataHolder: NSObject {
    
    private static var _instance:DataHolder!
    internal var favList:[Wall]
    
    override init() {
        favList = []
    }
    
    internal static func sharedInstance() -> DataHolder {
        if (DataHolder._instance == nil) {
            DataHolder._instance = DataHolder()
        }
        return DataHolder._instance;
    }
    
    internal func start() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUserDefaultsFromiCloud:", name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateiCloudFromUserDefaults:", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        self.loadData()
    }
    
    internal func saveData() -> Void {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        var favArray:[Dictionary<String, AnyObject>] = []
        for wall in favList {
            favArray.append(wall.convertToDict())
        }
        userDefault.setObject(favArray, forKey: "favList")
        
        userDefault.synchronize()
    }
    
    private func loadData() -> Void {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let currentFavList = userDefault.objectForKey("favList") {
            let favArray = currentFavList as! [Dictionary<String, AnyObject>]
            for wallDict in favArray {
                favList.append(Wall.convertFromDict(wallDict))
            }
        }
    }
    
    dynamic private func updateUserDefaultsFromiCloud(notification:NSNotification?) {
        
        //prevent loop of notifications by removing our observer before we update NSUserDefaults
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil);

        let iCloudDictionary = NSUbiquitousKeyValueStore.defaultStore().dictionaryRepresentation
        let userDefaults     = NSUserDefaults.standardUserDefaults()
        
        for (key, obj) in iCloudDictionary {
            userDefaults.setObject(obj, forKey: key as String)
        }
                
        userDefaults.synchronize()
        
        self.loadData()
        
        // re-enable NSUserDefaultsDidChangeNotification notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateiCloudFromUserDefaults:", name: NSUserDefaultsDidChangeNotification, object: nil)
    }

    
    dynamic private func updateiCloudFromUserDefaults(notification:NSNotification?) {
        let defaultsDictionary = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        let cloudStore         = NSUbiquitousKeyValueStore.defaultStore()
        
        for (key, obj) in defaultsDictionary {
               cloudStore.setObject(obj, forKey: key as String)
        }
        
        // let iCloud know that new or updated keys, values are ready to be uploaded
        cloudStore.synchronize()
    }

    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil);
    }
}
