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

class AddWallViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, RequestDelegate {
    
    private var locationManager:CLLocationManager!
    private var locationDelegateImpl:LocationDelegateImpl!
    private var userLocation:UserLocationAnnotation?
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    internal var newWall:Wall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tapOutside = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapOutside)
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "didDoubleTapMap:")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
        self.circleView.userInteractionEnabled = false
        
        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationItem.title = "New Wall"
        
        self.displayBackBtn(show: true)
        self.showLoader(show: true)
    }
    
    func dismissKeyboard(gestureRecognizer: UIGestureRecognizer) {
        nameLabel.resignFirstResponder()
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
    
    @IBAction func validateButton() {
        self.showLoader(show: true)
        guard let newName = nameLabel.text where newName != "" else {
            nameLabel.layer.borderWidth = 1
            nameLabel.layer.borderColor = UIColor.redColor().CGColor
            self.showLoader(show: false)
            return
        }
        
        let wall = Wall()
        wall.title = newName
        
        let currentCoordinate = mapView.centerCoordinate;
        let currentCoordinateNot2D = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        wall.latitude = currentCoordinate.latitude
        wall.longitude = currentCoordinate.longitude
        
        let xPoint = CGFloat(0)
        let yPoint = mapView.convertCoordinate(currentCoordinate, toPointToView: mapView).y
        let leftPoint = CGPoint(x: xPoint, y: yPoint)
        let leftCoordinate = mapView.convertPoint(leftPoint, toCoordinateFromView: mapView)
        let leftCoordinateNot2D = CLLocation(latitude: leftCoordinate.latitude, longitude: leftCoordinate.longitude)
        let distance = currentCoordinateNot2D.distanceFromLocation(leftCoordinateNot2D)
        wall.lenght = distance / 2;
        
        WebService.addWall(wall, delegate: self)
    }

    func wallIndexInFav() -> Int {
        for (index, currentWall) in DataHolder.sharedInstance().favList.enumerate() {
            if (currentWall.id == newWall.id) {
                return index
            }
        }
        return -1
    }
    
    //Request Delegate
    func responseFromWS(array aArray:Array<AnyObject>) {
        self.showLoader(show: false)
        for value in aArray {
            let dico = value as! Dictionary<String, AnyObject>
            newWall = Wall.parseFromDict(dico: dico)
        }
        let index = wallIndexInFav()
        if (index >= 0) {
            DataHolder.sharedInstance().favList.removeAtIndex(index)
        } else {
            DataHolder.sharedInstance().favList.append(newWall)
        }

        self.performSegueWithIdentifier("wallSegueID", sender: self)
    }
    
    func errorFromWS() {
        self.showLoader(show: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "wallSegueID" {
            let vc = segue.destinationViewController as! WallViewController
            vc.wall = newWall
            vc.backToRoot = true
        }
    }
    
    
    // LOCATION DELEGATE
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }
        
        let location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        userLocation = UserLocationAnnotation(coordinate: location2D)
        
        mapView.centerCoordinate = location2D
        var zoomIn = mapView.region;
        zoomIn.span.latitudeDelta /= 150
        zoomIn.span.longitudeDelta /= 150
        zoomIn.center = location2D
        mapView.setRegion(zoomIn, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        self.showLoader(show: false)
    }
    
    func didDoubleTapMap(gestureRecognizer: UIGestureRecognizer) {
        let coordinate = gestureRecognizer.locationInView(mapView)
        let location2D = mapView.convertPoint(coordinate, toCoordinateFromView: mapView)
        userLocation = UserLocationAnnotation(coordinate: location2D)
    }
    
    internal func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
