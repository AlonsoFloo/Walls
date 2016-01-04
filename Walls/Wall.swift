//
//  Wall.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import Foundation

public class Wall : NSObject {
    
    internal var id:Int = -1;
    internal var title:String = "";
    internal var latitude:Double = 0;
    internal var longitude:Double = 0;
    
    internal var messages:[Message] = [];
    
    internal func convertToDict() -> Dictionary<String, AnyObject> {
        var dic = Dictionary<String, AnyObject>()
        
        dic["id"] = id;
        dic["title"] = title;
        
        return dic
    }
    
    internal static func convertFromDict(dict:Dictionary<String, AnyObject>) -> Wall {
        let wall = Wall()
        
        wall.id = dict["id"] as! Int
        wall.title = dict["title"] as! String
        
        return wall
    }
}