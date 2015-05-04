//
//  RunSelectionViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/23/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

class RunSelectionViewController: UIViewController {

    // MARK: Public Declarations
    var appAlgorithmManager = AppAlgorithmManager()
    var apiAlgorithmManager = ApiAlgorithmManager()
    let ShowAlgorithmsIdentifier = "ShowAlgorithms"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func appButtonPressed(sender: UIButton) {
        appAlgorithmManager.shouldBeRun = true
        apiAlgorithmManager.shouldBeRun = false
        self.performSegueWithIdentifier(ShowAlgorithmsIdentifier, sender: self)
    }

    @IBAction func serverButtonPressed(sender: UIButton) {
        appAlgorithmManager.shouldBeRun = false
        apiAlgorithmManager.shouldBeRun = true
        self.performSegueWithIdentifier(ShowAlgorithmsIdentifier, sender: self)
    }
    
    @IBAction func bothButtonPressed(sender: UIButton) {
        appAlgorithmManager.shouldBeRun = true
        apiAlgorithmManager.shouldBeRun = true
        self.performSegueWithIdentifier(ShowAlgorithmsIdentifier, sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? AlgorithmPickerTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case ShowAlgorithmsIdentifier:
                    viewController.appAlgorithmManager = appAlgorithmManager
                    viewController.apiAlgorithmManager = apiAlgorithmManager
                default:
                    break
                }
            }
        }

    }
    
}
