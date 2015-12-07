//
//  UIDistantView.swift
//  Walls
//
//  Created by Inès MARTIN on 07/12/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Alamofire

class UIDistantView: UIImageView {
    
    internal var imageUrl:String!
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.redColor()
        Alamofire.request(.GET, imageUrl).response(){
            [weak self] (_, _, data, _) in
            if let goSelf = self {
                let image = UIImage(data: data! as NSData)
                goSelf.image = image
            }
        }
    }

}
