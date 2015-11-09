//
//  PointLocationAnnotation.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import MapKit

public class PointLocationAnnotation : NSObject, MKAnnotation {
    
    private var location:CLLocationCoordinate2D!
    private var locationTitle:String!
    internal var wall:Wall!
    
    public var title: String? { get {
            return self.locationTitle
        }
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get {
            return self.location
        }
    }
    
    init(coordinate aCoordinate:CLLocationCoordinate2D, title aTitle:String) {
        super.init()
        self.location = aCoordinate
        self.locationTitle = aTitle
    }
    
    init(wall aWall:Wall) {
        super.init()
        self.location = CLLocationCoordinate2D(latitude: aWall.latitude, longitude: aWall.longitude)
        self.locationTitle = aWall.title
        self.wall = aWall
    }
    
    public static func parseFromArray(array aArray:Array<AnyObject>) -> [PointLocationAnnotation] {
        var newPointList:[PointLocationAnnotation] = []
        for value in aArray {
            let dico = value as! Dictionary<String, String>
            
            let wall = Wall()
            wall.title = dico["nom"]!
            wall.latitude = Double(dico["latitude"]!)!
            wall.longitude = Double(dico["longitude"]!)!
            let newPoint = PointLocationAnnotation(wall: wall)
            newPointList.append(newPoint)
        }
        return newPointList
    }
    
}