//
//  WallViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 09/11/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Foundation

class WallViewController: BaseViewController, RequestDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var scrollViewView:UIView!
    var messageList:[Message]!
    var curentMaxIndex:Int = -1
    var bloqued:Bool = false
    let padding = 10
    var scrollWidth = 0
    var imageScrollView:UIImage!
    
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
        
        setupDataForScrollView();
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
        if (aArray.count == 0) {
            bloqued = true;
        } else {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
                self.messageList = Message.parseFromArray(array: aArray)
                self.setUpScrollContent();
                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    if let goSelf = self {
                        goSelf.showLoader(show: false)
                    }
                }
            }
        }
    }
    
    func errorFromWS() {
        bloqued = true;
        self.showLoader(show: false)
    }
    
    func setupDataForScrollView() {
        scrollViewView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)))
        
        self.scrollView.addSubview(scrollViewView)
        self.scrollView.layoutIfNeeded()
        imageScrollView = UIImage(named: "background");
        
        scrollWidth = padding;
        
        loadBackground(start: 0)
        loadMoreScrollViewContent()
    }
    
    func loadBackground(start aStart:CGFloat) {
        let imageSize = imageScrollView.size;
        let sizeToCover = self.scrollView.contentSize.width - aStart
        let numberOfImage = Int(sizeToCover / imageSize.width) + 1
        for (var i = 0; i < numberOfImage; i++) {
            let rect = CGRect(x: aStart + (CGFloat(i) * imageSize.width), y: 0, width: imageSize.width, height: scrollView.frame.size.height)
            let imageView = UIImageView(image: imageScrollView)
            imageView.userInteractionEnabled = false
            imageView.frame = rect
            scrollView.addSubview(imageView)
        }
    }
    
    func setUpScrollContent() {
        // Used into a thread
        // calculate width
        var height = padding
        let maxHeight = self.scrollView.contentSize.height;
        
        for message in messageList {
            let size = message.calculateViewSize()
            let origin = CGPoint(x: scrollWidth, y: height)
            height += padding + Int(size.height)
            if (origin.y + size.height >= maxHeight) {
                scrollWidth += padding + Int(size.width)
                height = padding
            }
            message.rect = CGRect(origin: origin, size: size)
        }

        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let goSelf = self {
                let previousWidth = goSelf.scrollView.contentSize.width
                for message in goSelf.messageList {
                    var view:UIView = UIView()
                    if (message.isImage) {
                        let viewImage = UIDistantView(frame: message.rect)
                        viewImage.imageUrl = message.content
                        view = viewImage
                    } else {
                        let labelView = UILabel(frame: message.rect)
                        labelView.text = message.content
                        labelView.font = UIFont.systemFontOfSize(message.fontSize)
                        labelView.backgroundColor = UIColor.blueColor()
                        labelView.numberOfLines = -1
                        view = labelView
                    }
                    goSelf.scrollViewView.frame.size = CGSize(width: CGFloat(goSelf.scrollWidth), height: goSelf.scrollView.contentSize.height)
                    goSelf.scrollView.addSubview(view)
                    //goSelf.scrollView.bringSubviewToFront(view)
                }
                
                goSelf.loadBackground(start: previousWidth)
                if #available(iOS 9.0, *) {
                    goSelf.scrollView.layoutIfNeeded()
                }
            }
        }
    }
    
    func loadMoreScrollViewContent() {
        if(!bloqued) {
            self.showLoader(show: true)
            curentMaxIndex++
            
            WebService.loadMessage(forWall: wall.id, at: curentMaxIndex, withDelegate: self)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == 0 && curentMaxIndex == 0
            || true) {
            self.loadMoreScrollViewContent();
        }
        print(scrollView.contentOffset.x)
        print(scrollView.contentSize.width)
    }
    
    
}