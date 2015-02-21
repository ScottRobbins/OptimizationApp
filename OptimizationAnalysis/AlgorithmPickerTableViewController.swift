//
//  AlgorithmPickerTableViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class AlgorithmPickerTableViewController: UITableViewController {
    
    var algorithmManager = AlgorithmManager()
    let FitFunctionSegueIdentifier = "ShowFitFunctions"
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.darkGrayColor()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DisplayInformation.Algorithm.allValues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlgorithmCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = DisplayInformation.Algorithm.allValues[indexPath.row].description
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        algorithmManager.algorithm = DisplayInformation.Algorithm.allValues[indexPath.row]
        self.performSegueWithIdentifier(FitFunctionSegueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? FitFunctionPickerTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case FitFunctionSegueIdentifier:
                    viewController.algorithmManager = algorithmManager
                default:
                    break
                }
            }
        }
    }
}
