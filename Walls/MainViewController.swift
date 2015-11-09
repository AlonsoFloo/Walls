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

class MainViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, RequestDelegate {

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
    internal var selectedPoint:PointLocationAnnotation!
    
    @IBOutlet weak var pointControlViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        pointList = []
        
        mapView.showsUserLocation = false
        displayListPoint(pointList)
        self.automaticallyAdjustsScrollViewInsets = false
        
        //Show research btn
        let searchBtn = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Done, target: self, action: Selector("searchBtnPressed"))
        self.navigationItem.rightBarButtonItems = [searchBtn]
        
        tableView.tableFooterView = UIView()
        self.showLoader(show: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchSegueID" {
            let vc = segue.destinationViewController as! SearchViewController
            vc.pointList = pointList;
        } else if segue.identifier == "wallSegueID" {
            let vc = segue.destinationViewController as! WallViewController
            vc.wall = selectedPoint.wall;
        }
    }
    
    func searchBtnPressed() {
        self.performSegueWithIdentifier("searchSegueID", sender: self)
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
            
            self.displayBackBtn(show: true)
        } else {
            self.displayBackBtn(show: false)
            mapViewBtn.enabled = true
            pointControlView.hidden = true
            
            mapViewHeight.constant = 200
            mapViewBottom.constant = 40
        }
        
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func displayMapViewPointControle(show doShow: Bool, point aPoint:PointLocationAnnotation!) {
        if (doShow) {
            pointControlView.hidden = false
        } else {
            pointControlView.hidden = true
        }
        
        if aPoint != nil {
            pointControlViewLabel.text = aPoint.title
            selectedPoint = aPoint
        } else {
            pointControlViewLabel.text = ""
        }
        
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func displayMapViewPointControlPressed() {
        self.performSegueWithIdentifier("wallSegueID", sender: self)
    }
    
    override func backBtnPressed() {
        displayMapView(full: false)
        displayMapViewPointControle(show: false, point:nil)
    }
    
    @IBAction func refreshBtnPressed() {
        self.showLoader(show: true)
        WebService.loadPointFromMap(mapView, delegate: self)
    }
    
    // LOCATION DELEGATE
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }

        let location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        userLocation = UserLocationAnnotation(coordinate: location2D)
        mapView.addAnnotation(userLocation!)
        
        mapView.centerCoordinate = location2D
        var zoomIn = mapView.region;
        zoomIn.span.latitudeDelta /= 50
        zoomIn.span.longitudeDelta /= 50
        mapView.setRegion(zoomIn, animated: true)
        self.locationManager.stopUpdatingLocation()
        refreshBtnPressed()
    }
    
    //Table View DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let point = pointList[indexPath.row]
        
        let tableViewCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "arroundMe")
        tableViewCell.imageView!.image = UIImage(named: "pointLoc")
        tableViewCell.textLabel!.text = point.title
        return tableViewCell
    }
    
    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPoint = pointList[indexPath.row]
        self.performSegueWithIdentifier("wallSegueID", sender: self)
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
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier!)
        }
        
        if identifier == "pointLoc" {
            view?.image = UIImage(named: "pointLoc")
        } else {
            view?.image = UIImage(named: "userLoc")
        }
        
        return view
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        if let pointLocation = view.annotation as? PointLocationAnnotation {
            displayMapViewPointControle(show: true, point: pointLocation)
        }
    }
    
    func mapView(mapView: MKMapView, didDeSelectAnnotationView view: MKAnnotationView) {
        displayMapViewPointControle(show: false, point:nil)
    }
    
    //Request Delegate
    func responseFromWS(array aArray:Array<AnyObject>) {
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
        
        mapView.removeAnnotations(pointList)
        pointList = newPointList
        mapView.addAnnotations(pointList)
        tableView.reloadData()
        self.showLoader(show: false)
    }
    
    func errorFromWS() {
        self.showLoader(show: false)
    }

}

