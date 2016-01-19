//
//  AddMessageViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import ColorSlider

class AddMessageViewController: BaseViewController, RequestDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: DrawableUIImage!
    @IBOutlet weak var colorPicker: ColorSlider!
    
    internal var wall:Wall!
    
    private var locationDelegateImpl:LocationDelegateImpl!
    private var userLocation:UserLocationAnnotation?
    private var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = wall.title
        
        let tapOutside = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.view.addGestureRecognizer(tapOutside)
        
        locationDelegateImpl = LocationDelegateImpl(delegate: self)
        userLocation = nil
        
        locationManager = CLLocationManager()
        locationManager.delegate = locationDelegateImpl
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        okBtn.enabled = false
        imageView.hidden = true
        colorPicker.hidden = true
        
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.showLoader(show: true, full: false)
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
    
    func dismissKeyboard(gestureRecognizer: UIGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    internal func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changedMode(sender: AnyObject) {
        textView.hidden = !textView.hidden;
        imageView.hidden = !imageView.hidden;
        colorPicker.hidden = !colorPicker.hidden;
    }
    
    @IBAction func okPressed() {
        self.showLoader(show: true)
        guard let newText = textView.text where newText != "" else {
            textView.layer.borderWidth = 1
            textView.layer.borderColor = UIColor.redColor().CGColor
            self.showLoader(show: false)
            return
        }
        
        let message = Message()
        message.content = newText
        message.isImage = false
        message.location = userLocation?.coordinate
        if (!imageView.hidden) {
            message.isImage = true
        }
        WebService.addMessage(message, forWall: wall, delegate: self)
    }
    
    @IBAction func changedColor(sender: AnyObject) {
        let color:UIColor = (sender as! ColorSlider).color
        var fRed: CGFloat = 0
        var fGreen: CGFloat = 0
        var fBlue: CGFloat = 0
        var fAlpha: CGFloat = 0
        if color.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            imageView.red = fRed
            imageView.green = fGreen
            imageView.blue = fBlue
        }
    }
    
    //Request Delegate
    func responseFromWS(array aArray:Array<AnyObject>) {
        self.showLoader(show: false)
        backBtnPressed()
    }
    
    func errorFromWS() {
        self.showLoader(show: false)
    }
    
    // LOCATION DELEGATE
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else {
            return
        }
        
        let location2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        userLocation = UserLocationAnnotation(coordinate: location2D)
        self.locationManager.stopUpdatingLocation()
        let inWall = self.wall.coordinateInWall((self.userLocation?.coordinate)!)
        if (inWall) {
            okBtn.enabled = true
        } else {
            UIAlertView(title: "Error", message: "You'r not in the wall", delegate: nil, cancelButtonTitle: "Ok").show()
            backBtnPressed()
        }
        
        self.showLoader(show: false, full: false)
    }
}