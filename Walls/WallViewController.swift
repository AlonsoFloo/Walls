//
//  WallViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Foundation

class WallViewController: BaseViewController, RequestDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var messageList:[Message]!
    
    var imageWall: UIImage!
    var imageWallList: [UIImageView]!
    
    internal var wall:Wall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = wall.title
        
        self.displayBackBtn(show: true)
        
        let addBtn = self.createItemButtonWithImage("addBtn", action: Selector("addBtnPressed"))
        self.navigationItem.rightBarButtonItems = [addBtn]
        
        self.showLoader(show: true)
        
        messageList = [Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message(), Message()]
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMessageSegueID" {
            let vc = segue.destinationViewController as! AddMessageViewController
            vc.wall = wall;
        }
    }
    
    func addBtnPressed() {
        self.performSegueWithIdentifier("addMessageSegueID", sender: self)
    }
    
    //Request Delegate
    func responseFromWS(array aArray:Array<AnyObject>) {
        self.showLoader(show: false)
    }
    
    func errorFromWS() {
        self.showLoader(show: false)
    }
    
}