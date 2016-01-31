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
        var point = CGPointMake((map.bounds.origin.x), (map.bounds.origin.y))
        let leftTop:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView:map)
        
        point = CGPointMake(map.bounds.origin.x + map.bounds.size.width, map.bounds.origin.y)
        let rightTop:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView: map)
        
        point = CGPointMake((map.bounds.origin.x), (map.bounds.origin.y + map.bounds.size.height))
        let leftBottom:CLLocationCoordinate2D = map.convertPoint(point, toCoordinateFromView: map)
        
        point = CGPointMake((map.bounds.origin.x + map.bounds.size.width), (map.bounds.origin.y + map.bounds.size.height))
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
        
        let url = NSURL(string: DOMAIN + "/wallsFromCoord")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
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
            "research" : search
        ]
        
        let url = NSURL(string: DOMAIN + "/research")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            if (response.result.isSuccess && response.result.value != nil) {
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
    
    
    static internal func addWall(wall:Wall, delegate aDelegate:RequestDelegate) {
        let bodyDic = [
            "nom" : wall.title,
            "latitude" : wall.latitude,
            "longitude" : wall.longitude,
            "distance" : wall.lenght,
            "created" : NSDate().timeIntervalSince1970,
            "description" : ""
        ]
        
        let url = NSURL(string: DOMAIN + "/insertWall")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
    
    static internal func addMessage(message:Message, forWall wall:Wall, delegate aDelegate:RequestDelegate) {
        let bodyDic = [
            "idWall": wall.id,
            "isImage": message.isImage ? "1" : "0",
            "content": message.content,
            "latitude": message.location.latitude,
            "longitude": message.location.longitude,
            "created": NSDate().timeIntervalSince1970,
            "description": message.content
        ]
        
        let url = NSURL(string: DOMAIN + "/insertMessage")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
    
    static internal func addLike(message:Message, forWall wall:Wall, delegate aDelegate:RequestDelegate) {
        let bodyDic = [
            "id": message.id
        ]
        
        let url = NSURL(string: DOMAIN + "/like")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
    
    static internal func addWarning(message:Message, forWall wall:Wall, delegate aDelegate:RequestDelegate) {
        let bodyDic = [
            "id": message.id
        ]
        
        let url = NSURL(string: DOMAIN + "/alert")
        let encodableURLRequest = NSURLRequest(URL: url!)
        let mutableURLRequest = encodableURLRequest.URLRequest
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(bodyDic, options: NSJSONWritingOptions.PrettyPrinted)
            mutableURLRequest.HTTPMethod = "POST"
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        Alamofire.request(mutableURLRequest).responseJSON { response in
            if (response.result.isSuccess) {
                let test = (response.result.value as! Array<AnyObject>)
                aDelegate.responseFromWS(array: test)
            } else {
                aDelegate.errorFromWS()
            }
        }
    }
}