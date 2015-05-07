//
//  GraphPickerTableViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/26/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

protocol GrapherPickerTableViewControllerDelegate : class {
    func graphWasSelected(graph : DisplayInformation.ReportGraph)
}

class GraphPickerTableViewController: UITableViewController {
    
    weak var delegate : GrapherPickerTableViewControllerDelegate?
    var reportType = ReportType.Single // default

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let report = DisplayInformation.getReportGraphsForReportType(reportType) {
            return report.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GraphCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = DisplayInformation.getReportGraphsForReportType(reportType)?[indexPath.row].description
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor.darkGrayColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true) {
            if let report = DisplayInformation.getReportGraphsForReportType(self.reportType) {
                self.delegate?.graphWasSelected(report[indexPath.row])
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
}
