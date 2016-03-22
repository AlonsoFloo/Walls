//
//  ViewController.swift
//  Walls
//
//  Created by Inès MARTIN on 26/10/2015.
//  Copyright © 2015 EPSI. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, RequestDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var selectedPoint: PointLocationAnnotation!

    internal var pointList: [PointLocationAnnotation]!

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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "wallSegueID" {
            let vc = segue.destinationViewController as! WallViewController
            vc.wall = selectedPoint.wall
        }
    }

    @IBAction func okBoutonClicked() {
        self.showLoader(show: true)
        let text = searchField.text
        WebService.searchPoint(text!, delegate: self)
    }

    @IBAction func addButtonPressed() {
        self.performSegueWithIdentifier("addWallSegueID", sender: self)
    }

    //TextField DELEGATE
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        okBoutonClicked()
        return true
    }

    //Table View DATASOURCE
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointList.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "pointLoc"

        if pointList.count == indexPath.row {
            identifier = "addCell"
        }

        let tableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        if pointList.count == indexPath.row {
        } else {
            let point = pointList[indexPath.row]
            tableViewCell.imageView!.image = UIImage(named: "pointLoc")
            tableViewCell.textLabel!.text = point.title
        }

        return tableViewCell
    }

    //Table View DELEGATE
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if pointList.count == indexPath.row {
            // show add
            addButtonPressed()
        } else {
            // show wall
            selectedPoint = pointList[indexPath.row]
            self.performSegueWithIdentifier("wallSegueID", sender: self)
        }
    }

    //Request Delegate
    func responseFromWS(array aArray: Array<AnyObject>) {
        pointList = PointLocationAnnotation.parseFromArray(array: aArray)
        tableView.reloadData()
        self.showLoader(show: false)
    }

    func errorFromWS() {
        self.showLoader(show: false)
    }

}
