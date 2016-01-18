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
    
    
    static let PADDINGWALLTOP = 90
    static let PADDINGWALLBOTTOM = 90
    static let MAXLABELDEGRES = 30
    
    @IBOutlet weak var scrollView: UIScrollView!
    var messageList:[Message]!
    var textColorList:[UIColor]!
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
        
        self.loadRightItems()
        
        setupDataForScrollView();
    }
    
    func loadRightItems() -> Void {
        let addBtn = self.createItemButtonWithImage("addBtn", action: Selector("addBtnPressed"))
        var imageBtn = "unFavBtn";
        let index = wallIndexInFav()
        if (index >= 0) {
            imageBtn = "favBtn"
        }
        let addFavBtn = self.createItemButtonWithImage(imageBtn, action: Selector("addFavBtn"))
        self.navigationItem.rightBarButtonItems = [addBtn, addFavBtn]
    }
    
    func wallIndexInFav() -> Int {
        for (index, currentWall) in DataHolder.sharedInstance().favList.enumerate() {
            if (currentWall.id == wall.id) {
                return index
            }
        }
        return -1
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
    
    func addFavBtn() {
        let index = wallIndexInFav()
        if (index >= 0) {
            DataHolder.sharedInstance().favList.removeAtIndex(index)
        } else {
            DataHolder.sharedInstance().favList.append(wall)
        }
        
        self.loadRightItems()
    }
    
    //Request Delegate
    func responseFromWS(array aArray:Array<AnyObject>) {
        if (aArray.count == 0) {
            bloqued = true;
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                if let goSelf = self {
                    goSelf.showLoader(show: false)
                }
            }
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
        self.scrollView.layoutIfNeeded()
        imageScrollView = UIImage(named: "background")
        self.scrollView.contentSize = self.view.frame.size
        
        textColorList = [UIColor.blackColor()
            , UIColor.blueColor()
            , UIColor.darkGrayColor()
            , UIColor.greenColor()
            , UIColor.purpleColor()
            , UIColor.whiteColor()
            , UIColor.yellowColor()]
        
        scrollWidth = padding;
        
        loadBackground(start: 0)
        loadMoreScrollViewContent()
    }
    
    func loadBackground(start aStart:CGFloat) {
        let imageSize = imageScrollView.size;
        let sizeToCover = self.scrollView.contentSize.width - aStart
        if (sizeToCover == 0) {
            return
        }
        let numberOfImage = Int(sizeToCover / imageSize.width) + 1
        for (var i = 0; i < numberOfImage; i++) {
            let rect = CGRect(x: aStart + (CGFloat(i) * imageSize.width), y: 0, width: imageSize.width, height: scrollView.contentSize.height)
            let imageView = UIImageView(image: imageScrollView)
            imageView.userInteractionEnabled = false
            imageView.frame = rect
            scrollView.addSubview(imageView)
        }
    }
    
    func setUpScrollContent() {
        // Used into a thread
        // calculate width
        var height = padding + WallViewController.PADDINGWALLTOP
        let maxHeight = self.scrollView.contentSize.height - CGFloat(WallViewController.PADDINGWALLBOTTOM)
        var maxWidth = 0
        
        for message in messageList {
            let size = message.calculateViewSize()
            let origin = CGPoint(x: scrollWidth, y: height)
            height += padding + Int(size.height)
            if (origin.y + size.height >= maxHeight) {
                scrollWidth += padding + Int(maxWidth)
                height = padding + WallViewController.PADDINGWALLTOP
            }
            message.rect = CGRect(origin: origin, size: size)
            
            if (Int(size.width) > maxWidth) {
                maxWidth = Int(size.width)
            }
        }
        
        scrollWidth += padding + Int(maxWidth)

        
        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let goSelf = self {
                let previousWidth = goSelf.scrollView.contentSize.width
                
                var currentSize = goSelf.scrollView.contentSize
                currentSize.width = CGFloat(goSelf.scrollWidth)
                if (currentSize.width > goSelf.scrollView.contentSize.width) {
                    goSelf.scrollView.contentSize = currentSize
                }
                
                goSelf.loadBackground(start: previousWidth)
                
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
                        let tabSize = goSelf.textColorList.count;
                        let range:UInt32 = UInt32(tabSize)
                        let indexColor = Int(arc4random_uniform(range))
                        labelView.textColor = goSelf.textColorList[indexColor]
                        let angleDouble = UInt32(WallViewController.MAXLABELDEGRES*2)
                        let angleRotation = Double(arc4random_uniform(angleDouble)) - Double(WallViewController.MAXLABELDEGRES)
                        let angleRadian = CGFloat(angleRotation * (M_1_PI / 180))
                        labelView.transform = CGAffineTransformMakeRotation(angleRadian)
                        
                        labelView.numberOfLines = -1
                        view = labelView
                    }
                    goSelf.scrollView.addSubview(view)
                    goSelf.scrollView.bringSubviewToFront(view)
                }
                
                
                if #available(iOS 9.0, *) {
                    goSelf.scrollView.layoutIfNeeded()
                }
            }
        }
    }
    
    func loadMoreScrollViewContent() {
        if(!bloqued) {
            self.showLoader(show: true, full: false)
            curentMaxIndex++
            
            WebService.loadMessage(forWall: wall.id, at: curentMaxIndex, withDelegate: self)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == (scrollView.contentSize.width - scrollView.frame.width)) {
            self.loadMoreScrollViewContent()
        }
    }
    
    
}