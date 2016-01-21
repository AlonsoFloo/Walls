//
//  WallPopUpViewController.swift
//  Walls
//
//  Created by Flalo on 21/01/2016.
//  Copyright © 2016 EPSI. All rights reserved.
//

import UIKit
import Foundation

class WallPopUpViewController: BaseViewController {
    internal var wall:Wall!
    internal var message:Message!
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageView: UIDistantView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = wall.title
        
        self.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        self.displayBackBtn(show: true)
        
        self.setUpView()
    }
    
    func setUpView() {
        if (message.isImage) {
            self.labelView.hidden = true
            self.imageView.setUrl(message.content)
        } else {
            self.imageView.hidden = true
            labelView.text = message.content
            labelView.font = UIFont.systemFontOfSize(message.fontSize)
            labelView.numberOfLines = -1
        }
    }
    
}
