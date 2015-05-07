//
//  AlgorithmManager.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//
//  NOTE: This is as close to an abstract class as I could get

import Foundation

let kAlgorithmsHaveUpdated = "kAlgorithmsHaveUpdated"
let kFitFunctionsHaveUpdated = "kFitFunctionsHaveUpdated"


enum ReportType {
    case Single
    case Average
    case Api
}

class AlgorithmManager {
    // MARK: Public Declarations
    var shouldBeRun = false
    var algorithm = Algorithm()
        
    // MARK: Initializers
    init() {
        
    }
    
}