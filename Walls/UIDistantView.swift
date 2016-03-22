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

    internal var imageUrl: String!
    internal var isDisplayed: Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let url = imageUrl else {
            isDisplayed = true
            return
        }

        if !isDisplayed {
            isDisplayed = true

            let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            indicator.startAnimating()
            indicator.center = self.center
            self.superview?.addSubview(indicator)

            Alamofire.request(.GET, url).response() {
                [weak self] (_, _, data, _) in
                if let goSelf = self {
                    indicator.removeFromSuperview()
                    let image = UIImage(data: data! as NSData)
                    goSelf.image = image
                }
            }
        }
    }

    func setUrl(url: String) {
        imageUrl = url
        if !isDisplayed {
            self.layoutSubviews()
        }
    }

}
