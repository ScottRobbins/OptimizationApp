//
//  GraphPickerNavigationController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/28/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

class GraphPickerNavigationController: UINavigationController {

    var rootViewController : GraphPickerTableViewController? {
        return viewControllers[0] as? GraphPickerTableViewController
    }
}
