//
//  WallPopUpViewController.swift
//  Walls
//
//  Created by Flalo on 21/01/2016.
//  Copyright © 2016 EPSI. All rights reserved.
//

import UIKit
import Foundation

class WallPopUpViewController: BaseViewController, RequestDelegate {
    internal var wall: Wall!
    internal var message: Message!
    internal var loadLike: Bool = false

    @IBOutlet weak var btnWarning: UIButton!
    @IBOutlet weak var btnLike: UIButton!
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
        if message.isImage {
            self.labelView.hidden = true
            self.imageView.setUrl(message.content)
        } else {
            self.imageView.hidden = true
            labelView.text = message.content
            labelView.font = UIFont(name: "Bradley Hand", size: message.fontSize)
            labelView.numberOfLines = -1
        }

        if DataHolder.sharedInstance().likeList.contains(message.id) {
            btnLike.enabled = false
        }

        if DataHolder.sharedInstance().warningList.contains(message.id) {
            btnWarning.enabled = false
        }
    }

    @IBAction func warningBtnTouch() {
        self.showLoader(show: true)
        loadLike = false
        WebService.addWarning(message, forWall: wall, delegate: self)
    }

    @IBAction func likeBtnTouch() {
        self.showLoader(show: true)
        loadLike = true
        WebService.addLike(message, forWall: wall, delegate: self)
    }

    //Request Delegate
    func responseFromWS(array aArray: Array<AnyObject>) {
        self.showLoader(show: false)
        if loadLike {
            DataHolder.sharedInstance().likeList.append(message.id)
            btnLike.enabled = false
        } else {
            DataHolder.sharedInstance().warningList.append(message.id)
            btnWarning.enabled = false
        }
    }

    func errorFromWS() {
        self.showLoader(show: false)
    }
}
