//
//  LocationDelegateImpl.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class LocationDelegateImpl : NSObject, CLLocationManagerDelegate {
    
    private var seenError:Bool = false
    internal let delegate:CLLocationManagerDelegate;
    
    init(delegate:CLLocationManagerDelegate) {
        self.delegate = delegate
    }
    
    // Location Manager Delegate stuff
    @objc func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if (seenError == false) {
            seenError = true
            // show error
            let alert = UIAlertView()
            alert.title = "Location"
            alert.message = "We cannot get acces to your localisation"
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }
        
        let eventDate = location.timestamp
        let howRecent = eventDate.timeIntervalSinceNow
        
        if (abs(howRecent) < 15.0 && location.horizontalAccuracy < 15 ) {
            seenError = false
            delegate.locationManager!(manager, didUpdateLocations: [location])
        }
    }
}
