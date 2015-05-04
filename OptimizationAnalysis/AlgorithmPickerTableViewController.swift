//
//  AlgorithmPickerTableViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class AlgorithmPickerTableViewController: UITableViewController {
    
    var appAlgorithmManager = AppAlgorithmManager()
    var apiAlgorithmManager = ApiAlgorithmManager()
    let FitFunctionSegueIdentifier = "ShowFitFunctions"
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.darkGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("algorithmsHaveUpdated"), name: kAlgorithmsHaveUpdated, object: nil)
        if apiAlgorithmManager.shouldBeRun == true {
            apiAlgorithmManager.getAlgorithms()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("algorithmsHaveUpdated"), name: kAlgorithmsHaveUpdated, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kAlgorithmsHaveUpdated, object: nil)
    }
    
    // MARK: Event Responders
    func algorithmsHaveUpdated() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiAlgorithmManager.shouldBeRun && !appAlgorithmManager.shouldBeRun {
            return apiAlgorithmManager.apiAlgorithms.count
        } else {
            return DisplayInformation.DisplayAlgorithm.allValues.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlgorithmCell", forIndexPath: indexPath) as! UITableViewCell

        if apiAlgorithmManager.shouldBeRun && !appAlgorithmManager.shouldBeRun {
            cell.textLabel?.text = apiAlgorithmManager.apiAlgorithms[indexPath.row].name
        } else {
            cell.textLabel?.text = DisplayInformation.DisplayAlgorithm.allValues[indexPath.row].description
        }
        
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if apiAlgorithmManager.shouldBeRun && !appAlgorithmManager.shouldBeRun {
            apiAlgorithmManager.algorithm = apiAlgorithmManager.apiAlgorithms[indexPath.row]
        } else {
            appAlgorithmManager.algorithm = DisplayInformation.constructAlgorithm(DisplayInformation.DisplayAlgorithm.allValues[indexPath.row])
            apiAlgorithmManager.algorithm = appAlgorithmManager.algorithm
        }
        
        self.performSegueWithIdentifier(FitFunctionSegueIdentifier, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? FitFunctionPickerTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case FitFunctionSegueIdentifier:
                    viewController.appAlgorithmManager = appAlgorithmManager
                    viewController.apiAlgorithmManager = apiAlgorithmManager
                default:
                    break
                }
            }
        }
    }
}
