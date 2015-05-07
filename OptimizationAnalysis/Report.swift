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
    var bestM = 0.0
    var computationTime = Double()
    var iterations = [Iteration]()
    var allBestMs : [Double] {
        return iterations.map({$0.bestM})
    }
    var minimumBestM : Double {
        return allBestMs.reduce(iterations[0].bestM, combine: min)
    }
    var maximumBestM : Double {
        return allBestMs.reduce(iterations[0].bestM, combine: max)
    }
}