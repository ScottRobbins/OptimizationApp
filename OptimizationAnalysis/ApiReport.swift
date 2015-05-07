//
//  ApiReport.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 5/6/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class ApiReport {

    var id = String()
    var algorithmName = String()
    var fitFunctionName = String?()
    var bestM = 0.0
    var computationTime = Double()
    var stdDevBestM = Double()
    var stdDevComputationTime = Double()
    var roundTripTime = Double()
}