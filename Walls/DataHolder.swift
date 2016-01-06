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
    
    internal func saveData() -> Void {
        let userDefault = NSUserDefaults()
        
        var favArray:[Dictionary<String, AnyObject>] = []
        for wall in favList {
            favArray.append(wall.convertToDict())
        }
        userDefault.setObject(favArray, forKey: "sync_favList")
        
        userDefault.synchronize()
    }
    
    internal func loadData() -> Void {
        let userDefault = NSUserDefaults()
        
        if let currentFavList = userDefault.objectForKey("sync_favList") {
            let favArray = currentFavList as! [Dictionary<String, AnyObject>]
            for wallDict in favArray {
                favList.append(Wall.convertFromDict(wallDict))
            }
        }
    }
}
