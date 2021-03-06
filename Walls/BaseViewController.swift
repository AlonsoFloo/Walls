//
//  BaseViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var activityIndicatorView: UIActivityIndicatorView!
    internal var backToRoot: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationItem.title = "Walls"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayBackBtn(show doShow: Bool) {
        if doShow {
            let backBtn = self.createItemButtonWithImage("backBtn", action: Selector("backBtnPressed"))
            self.navigationItem.leftBarButtonItem = backBtn
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }

    func backBtnPressed() {
        if backToRoot {
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    internal func createItemButtonWithImage(image: String, action aAction: Selector) -> UIBarButtonItem {
        let image = UIImage(named: image)
        let frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
        let btn = UIButton(frame: frame)
        btn.addTarget(self, action: aAction, forControlEvents: UIControlEvents.TouchUpInside)
        btn.setBackgroundImage(image, forState: UIControlState.Normal)
        btn.showsTouchWhenHighlighted = false
        return UIBarButtonItem(customView: btn)
    }

    func showLoader(show doShow: Bool) {
        self.showLoader(show: doShow, full: true)
    }

    func showLoader(show doShow: Bool, full showFull: Bool) {
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

            activityIndicatorView.center=self.view.center

            if showFull {
                activityIndicatorView.frame = self.view.frame
            } else {
                let size = CGSize(width: self.view.frame.size.width, height: 60)
                let point = CGPoint(x: 0, y: 64)
                activityIndicatorView.frame = CGRect(origin: point, size: size)
            }
            activityIndicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.20)
            activityIndicatorView.hidesWhenStopped = true
            self.view.addSubview(activityIndicatorView)
        }

        if doShow {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }

}
