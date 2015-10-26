//
//  ViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class MainViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapViewBtn: UIButton!
    
    private var locationManager:CLLocationManager!
    private var locationDelegateImpl:LocationDelegateImpl!
    private var userLocation:UserLocationAnnotation?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil;
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = false;
    }
    
    override func viewDidAppear(animated: Bool) {
        if #available(iOS 8.0, *) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if #available(iOS 9.0, *) {
            self.locationManager.requestLocation()
        } else {
            self.locationManager.startUpdatingLocation()
        };
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mapViewClickInside(sender: AnyObject) {
        displayMapView(full: true)
    }
    
    func displayMapView(full isFull: Bool) {
        if (isFull) {
            let superViewHeight = self.view.frame.height;
            mapViewHeight.constant = superViewHeight
            mapViewBtn.enabled = false
            
            let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: Selector("backBtnPressed"))
            self.navigationItem.leftBarButtonItem = backBtn
        } else {
            self.navigationItem.leftBarButtonItem = nil
            mapViewBtn.enabled = true
            
            mapViewHeight.constant = 200
        }
        
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func backBtnPressed() {
        displayMapView(full: false)
    }
    
    // LOCATION DELEGATE
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }

        let location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        if (userLocation == nil) {
            userLocation = UserLocationAnnotation(coordinate: location2D)
            mapView.addAnnotation(userLocation!)
        } else {
            //userLocation?.coordinate = location2D
            mapView.reloadInputViews()
        }
        
        mapView.centerCoordinate = location2D
    }
    
    //Table View DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell:UITableViewCell = UITableViewCell()
        return tableViewCell
    }
    
    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MK Map View DELEGATE
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "userLoc"
        
        var view: MKAnnotationView? = nil
        if let dequeView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
            view = dequeView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        return view
    }

}

