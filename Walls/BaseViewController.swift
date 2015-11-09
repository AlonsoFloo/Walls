//
//  BaseViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var activityIndicatorView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Walls"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayBackBtn(show doShow:Bool) {
        if (doShow) {
            let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Done, target: self, action: Selector("backBtnPressed"))
            self.navigationItem.leftBarButtonItem = backBtn
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func backBtnPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showLoader(show doShow:Bool) {
        if activityIndicatorView == nil {
            activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            
            activityIndicatorView.center=self.view.center
            activityIndicatorView.frame = self.view.frame
            activityIndicatorView.backgroundColor = UIColor(white: 0.0, alpha: 0.20)
            activityIndicatorView.hidesWhenStopped = true
            self.view.addSubview(activityIndicatorView)
        }
        
        if (doShow) {
            activityIndicatorView.startAnimating();
        } else {
            activityIndicatorView.stopAnimating();
        }
    }
    
}