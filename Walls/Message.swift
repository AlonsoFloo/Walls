//
//  Message.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import Foundation
import MapKit

public class Message: NSObject {

    internal static let MAXWIDTH = 230
    internal static let MINWIDTH = 60

    internal var id: Int = 0
    internal var like: Int = 0
    internal var alert: Int = 0
    internal var content: String = ""
    internal var isImage: Bool = false
    internal var size: Int = 0
    internal var fontSize: CGFloat = 0
    internal var location: CLLocationCoordinate2D!
    internal var rect: CGRect!


    public static func parseFromArray(array aArray: Array<AnyObject>) -> [Message] {
        var newPointList: [Message] = []
        for value in aArray {
            let dico = value as! Dictionary<String, AnyObject>

            let mess = Message()
            mess.id = Int(dico["id"]! as! String)!
            mess.like = Int(dico["like"]! as! String)!
            mess.isImage = Int(dico["isImage"]! as! String)! == 1
            mess.content = dico["content"]! as! String
            mess.alert = Int(dico["alert"]! as! String)!

            let latitude = Double(dico["latitude"]! as! String)!
            let longitude = Double(dico["longitude"]! as! String)!
            mess.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // calculate the size
            mess.size = mess.like * 3 - mess.alert * 2
            if mess.size > MAXWIDTH {
                mess.size = MAXWIDTH
            } else if mess.size < MINWIDTH {
                mess.size = MINWIDTH
            }

            mess.fontSize = CGFloat((mess.size * 100)/MAXWIDTH) / 2

            newPointList.append(mess)
        }
        return newPointList
    }

    public func calculateViewSize() -> CGSize {
        var width: CGFloat = CGFloat(size)
        var height: CGFloat = 0
        if isImage {
            height = width * 183 / 118
        } else {
            let text = NSString(string: content)
            //let font = UIFont.systemFontOfSize(fontSize)
            let font = UIFont(name: "Bradley Hand", size: fontSize)!
            let sizeWithAttributes = [NSFontAttributeName: font]
            let sizeLimit = CGSize(width: width, height: 99999)
            let textSize = text.boundingRectWithSize(sizeLimit, options:  NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: sizeWithAttributes, context: nil).size
            height = textSize.height
            width = textSize.width
        }
        return CGSize(width: width, height: height)
    }

}
