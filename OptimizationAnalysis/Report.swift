//
//  Report.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 1/31/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class Report {
    var algorithmName = String()
    var fitFunctionName = String?()
    var bestSolution = [Double]()
    var bestM = Double()
    var computationTime = Double()
    var dimension = Int()
}