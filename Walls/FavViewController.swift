//
//  ViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class FavViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    internal var selectedPoint:Wall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "Bookmarks"
        
        self.displayBackBtn(show: true)
        
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "wallSegueID" {
            let vc = segue.destinationViewController as! WallViewController
            vc.wall = selectedPoint;
        }
    }
    
    //Table View DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DataHolder.sharedInstance().favList.count == 0 {
            return 1;
        }
        return DataHolder.sharedInstance().favList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier: String = "fav"
        if DataHolder.sharedInstance().favList.count == 0 {
            identifier = "noWallsFound"
        }
        
        let tableViewCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        
        if DataHolder.sharedInstance().favList.count == 0 {
            tableViewCell.textLabel!.text = "No Walls Found"
        } else {
            let point = DataHolder.sharedInstance().favList[indexPath.row]
            tableViewCell.imageView!.image = UIImage(named: "pointLoc")
            tableViewCell.textLabel!.text = point.title
        }
        
        return tableViewCell
    }
    
    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if DataHolder.sharedInstance().favList.count > 0 {
            selectedPoint = DataHolder.sharedInstance().favList[indexPath.row]
            self.performSegueWithIdentifier("wallSegueID", sender: self)
        }
    }
    
}

