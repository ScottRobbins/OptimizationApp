//
//  FitFunctionPickerTableViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class FitFunctionPickerTableViewController: UITableViewController {
    
    // MARK: Public Declarations
    var appAlgorithmManager : AppAlgorithmManager?
    var apiAlgorithmManager : ApiAlgorithmManager?
    let ParameterSelectionSegueIdentifier = "ShowParameters"
    
    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.darkGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fitFunctionsHaveUpdated"), name: kFitFunctionsHaveUpdated, object: nil)
        if apiAlgorithmManager?.shouldBeRun == true {
            apiAlgorithmManager?.getFitFunctions()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fitFunctionsHaveUpdated"), name: kFitFunctionsHaveUpdated, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kFitFunctionsHaveUpdated, object: nil)
    }
    
    // MARK: Notification Responders
    func fitFunctionsHaveUpdated() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            return apiAlgorithmManager!.apiFitFunctions.count
        } else {
            return DisplayInformation.DisplayFitFunction.allValues.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FitFunctionCell", forIndexPath: indexPath) as! UITableViewCell
        
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            cell.textLabel?.text = apiAlgorithmManager?.apiFitFunctions[indexPath.row].name
        } else {
            cell.textLabel?.text = DisplayInformation.DisplayFitFunction.allValues[indexPath.row].description
        }
        
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.backgroundColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            apiAlgorithmManager!.fitFunction = apiAlgorithmManager!.apiFitFunctions[indexPath.row]
        } else {
            appAlgorithmManager?.fitFunction = DisplayInformation.constructFitFunction(DisplayInformation.DisplayFitFunction.allValues[indexPath.row])
            apiAlgorithmManager?.fitFunction = DisplayInformation.constructFitFunction(DisplayInformation.DisplayFitFunction.allValues[indexPath.row])
        }
        
        self.performSegueWithIdentifier(ParameterSelectionSegueIdentifier, sender: self)
    }
    
    // MARK: Navigation Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ParameterSelectionViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case ParameterSelectionSegueIdentifier:
                    viewController.appAlgorithmManager = appAlgorithmManager
                    viewController.apiAlgorithmManager = apiAlgorithmManager
                default:
                    break
                }
            }
        }
    }
}
