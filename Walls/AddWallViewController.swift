//
//  AddWallViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class AddWallViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    private var locationManager:CLLocationManager!
    private var locationDelegateImpl:LocationDelegateImpl!
    private var userLocation:UserLocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationItem.title = "New Wall"
        
        self.displayBackBtn(show: true)
        self.showLoader(show: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if userLocation == nil {
            self.locationManager.requestWhenInUseAuthorization()
            
            if #available(iOS 9.0, *) {
                self.locationManager.requestLocation()
            } else {
                self.locationManager.startUpdatingLocation()
            };
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // LOCATION DELEGATE
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }
        
        let location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        userLocation = UserLocationAnnotation(coordinate: location2D)
        /*mapView.addAnnotation(userLocation!)
        
        mapView.centerCoordinate = location2D
        var zoomIn = mapView.region;
        zoomIn.span.latitudeDelta /= 150
        zoomIn.span.longitudeDelta /= 150
        zoomIn.center = location2D
        mapView.setRegion(zoomIn, animated: true)*/
        self.locationManager.stopUpdatingLocation()
        
        self.showLoader(show: false)
    }
    
    //MK Map View DELEGATE
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var identifier: String? = nil
        if let _ = annotation as? UserLocationAnnotation {
            identifier = "userLoc"
        }
        
        var view: MKAnnotationView? = nil
        if let dequeView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier!) {
            view = dequeView
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier!)
        }
        
        if identifier == "pointLoc" {
            view?.image = UIImage(named: "pointLoc")
        }
        
        return view
    }
    
}