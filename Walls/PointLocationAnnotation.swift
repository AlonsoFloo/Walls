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
    
    private var location:CLLocationCoordinate2D!;
    private var locationTitle:String!;
    
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
    
}