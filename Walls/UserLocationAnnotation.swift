//
//  UserLocationAnnotation.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import MapKit

public class UserLocationAnnotation: NSObject, MKAnnotation {

    private var location: CLLocationCoordinate2D!

    public var coordinate: CLLocationCoordinate2D {
        get {
            return self.location
        }
    }

    init(coordinate aCoordinate: CLLocationCoordinate2D) {
        super.init()
        self.location = aCoordinate
    }


}
