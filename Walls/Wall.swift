//
//  Wall.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import Foundation
import MapKit

public class Wall : NSObject {
    
    internal var id:Int = -1
    internal var title:String = ""
    internal var latitude:Double = 0
    internal var longitude:Double = 0
    internal var lenght:Double = 0
    
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
    
    internal func coordinateInWall(coord:CLLocationCoordinate2D) -> Bool {
        let dlon = coord.longitude - longitude
        let dlat = coord.latitude - latitude
        let a = (pow(sin(dlat/2), 2) + cos(latitude) * cos(coord.latitude) * pow(sin(dlon/2), 2))
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let distance = 6373000 * c
        return distance < lenght
    }
    
    public static func parseFromDict(dico aDico:Dictionary<String, AnyObject>) -> Wall {
        let wall = Wall()
        wall.id = Int(aDico["id"]! as! String)!
        wall.title = aDico["nom"]! as! String
        wall.latitude = Double(aDico["latitude"]! as! String)!
        wall.longitude = Double(aDico["longitude"]! as! String)!
        wall.lenght = Double(aDico["distance"]! as! String)!
        return wall
    }
}