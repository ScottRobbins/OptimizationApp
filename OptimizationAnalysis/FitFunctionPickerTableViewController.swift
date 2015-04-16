//
//  FitFunctionPickerTableViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class FitFunctionPickerTableViewController: UITableViewController {
    
    var algorithmManager : AlgorithmManager? = nil
    let ParameterSelectionSegueIdentifier = "ShowParameters"
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return DisplayInformation.FitFunction.allValues.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FitFunctionCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = DisplayInformation.FitFunction.allValues[indexPath.row].description
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        algorithmManager?.fitFunction = DisplayInformation.FitFunction.allValues[indexPath.row]
        self.performSegueWithIdentifier(ParameterSelectionSegueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ParameterSelectionViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case ParameterSelectionSegueIdentifier:
                    viewController.algorithmManager = algorithmManager
                default:
                    break
                }
            }
        }
    }
}
