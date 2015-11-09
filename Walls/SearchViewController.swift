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

class SearchViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    internal var pointList:[PointLocationAnnotation]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Search"
        
        tableView.tableFooterView = UIView()
        
        self.displayBackBtn(show: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBoutonClicked() {
        let text = searchField.text
    }
    
    //TextField DELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        okBoutonClicked()
        return true;
    }
    
    //Table View DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointList.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "pointLoc"
        
        if (pointList.count == indexPath.row) {
            identifier = "addCell"
        }
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        
        if (pointList.count == indexPath.row) {
        } else {
            let point = pointList[indexPath.row]
            tableViewCell.imageView!.image = UIImage(named: "blueDot")
            tableViewCell.textLabel!.text = point.title
        }
        
        return tableViewCell
    }
    
    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (pointList.count == indexPath.row) {
            // show add
        } else {
            // show wall
            let point = pointList[indexPath.row]
        }
    }
    
}