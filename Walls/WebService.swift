//
//  WebService.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

public class WebService : NSObject {
    
    static private let DOMAIN = "http://perso.montpellier.epsi.fr/~nicolas.guigui/wallws"
    
    static internal func loadPointFromMap(map:MKMapView, delegate aDelegate:RequestDelegate) {
        var point = CGPoint(x: 0, y: 0)
        let leftTop:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView:map)
        
        point = CGPoint(x: 0, y: map.bounds.width)
        let rightTop:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView: map)
        
        point = CGPoint(x: map.bounds.height, y: 0)
        let leftBottom:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView: map)
        
        point = CGPoint(x: map.bounds.height, y: map.bounds.width)
        let rightBottom:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView: map)
        
        let bodyDic = [
            "topLeft" : [
                "lat" : leftTop.latitude,
                "lon" : leftTop.longitude
            ],
            "topRight" : [
                "lat" : rightTop.latitude,
                "lon" : rightTop.longitude
            ],
            "bottomRight" : [
                "lat" : rightBottom.latitude,
                "lon" : rightBottom.longitude
            ],
            "bottomLeft" : [
                "lat" : leftBottom.latitude,
                "lon" : leftBottom.longitude
            ],
            "center" : [
                "lat" : map.region.center.latitude,
                "lon" : map.region.center.longitude
            ]
        ]
        
        Alamofire.request(.POST, DOMAIN + "/wallsFromCoord", parameters: [:], encoding: .Custom({
            (convertible, params) in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
                mutableRequest.HTTPBody = jsonData
            } catch let error as NSError {
                print(error)
            }
            
            return (mutableRequest, nil)
        })).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
    
    static internal func searchPoint(search:String, delegate aDelegate:RequestDelegate) {
        let bodyDic = [
            "search" : search
        ]
        
        Alamofire.request(.POST, DOMAIN + "/wallsFromCoord", parameters: [:], encoding: .Custom({
            (convertible, params) in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            do {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
                mutableRequest.HTTPBody = jsonData
            } catch let error as NSError {
                print(error)
            }
            
            return (mutableRequest, nil)
        })).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
    
    static internal func loadMessage(forWall wall:Int, at page:Int, withDelegate aDelegate:RequestDelegate) {
        Alamofire.request(.POST, DOMAIN + "/messages/\(wall)/\(page)", parameters: [:]).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
}