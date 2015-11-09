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
    
    @IBOutlet weak var mapViewBottom: NSLayoutConstraint!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapViewBtn: UIButton!
    @IBOutlet weak var pointControlView: UIView!
    
    private var locationManager:CLLocationManager!
    private var locationDelegateImpl:LocationDelegateImpl!
    private var userLocation:UserLocationAnnotation?
    
    private var pointList:[PointLocationAnnotation]!
    @IBOutlet weak var pointControlViewLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        let locationPointBase = CLLocation(latitude: 40.7029741,longitude: -74.2598655)
        let location2D = CLLocationCoordinate2DMake(locationPointBase.coordinate.latitude, locationPointBase.coordinate.longitude)
        let point = PointLocationAnnotation(coordinate: location2D, title: "MontpellierTest");
        pointList = [point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point, point]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = false
        displayListPoint(pointList)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Show research btn
        let searchBtn = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("searchBtnPressed"))
        self.navigationItem.leftBarButtonItem = searchBtn
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
    
    func searchBtnPressed() {
        
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
    
    func displayListPoint(points:[PointLocationAnnotation]) {
        for point in points {
            mapView.addAnnotation(point)
        }
    }
    
    func displayMapView(full isFull: Bool) {
        if (isFull) {
            let superViewHeight = self.view.frame.height;
            mapViewHeight.constant = superViewHeight
            mapViewBottom.constant = 0
            mapViewBtn.enabled = false
            
            let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: Selector("backBtnPressed"))
            self.navigationItem.leftBarButtonItem = backBtn
        } else {
            self.navigationItem.leftBarButtonItem = nil
            mapViewBtn.enabled = true
            pointControlView.hidden = true
            
            mapViewHeight.constant = 200
            mapViewBottom.constant = 40
        }
        
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func displayMapViewPointControle(show doShow: Bool, title aTitle:String) {
        if (doShow) {
            pointControlView.hidden = false
        } else {
            pointControlView.hidden = true
        }
        
        pointControlViewLabel.text = aTitle
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func backBtnPressed() {
        displayMapView(full: false)
        displayMapViewPointControle(show: false, title: "")
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
        return pointList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let point = pointList[indexPath.row]
        
        let tableViewCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "arroundMe")
        tableViewCell.imageView!.image = UIImage(named: "blueDot")
        tableViewCell.textLabel!.text = point.title
        return tableViewCell
    }
    
    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MK Map View DELEGATE
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var identifier: String? = nil
        if let _ = annotation as? UserLocationAnnotation {
            identifier = "userLoc"
        } else {
            identifier = "pointLoc"
        }
        
        var view: MKAnnotationView? = nil
        if let dequeView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier!) {
            view = dequeView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if identifier == "pointLoc" {
        } else {
            view?.image = UIImage(named: "blueDot")
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let pointLocation = view.annotation as? PointLocationAnnotation,
            let pointTitle = pointLocation.title {
            displayMapViewPointControle(show: true, title: pointTitle)
        }
    }
    
    func mapView(mapView: MKMapView, didDeSelectAnnotationView view: MKAnnotationView) {
        displayMapViewPointControle(show: false, title: "")
    }

}

