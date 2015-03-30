//
//  AverageReport.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 1/31/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class AverageReport {
    var reports = [Report]()
    var algorithmName = String()
    var fitFunctionName = String?()
    var averageBestM = Double()
    var averageComputationTime = Double()
    var stdDevBestM = Double()
    var stdDevComputationTime = Double()
    var dimension = Int()
    var allReportsBestMs : [Double] {
        return reports.map({$0.bestM})
    }
    var allReportsComputationTimes : [Double] {
        return reports.map({$0.computationTime})
    }
    var minimumReportsBestM : Double {
        return allReportsBestMs.reduce(reports[0].bestM, combine: min)
    }
    var maximumReportsBestM : Double {
        return allReportsBestMs.reduce(reports[0].bestM, combine: max)
    }
    var minimumReportsComputationTime : Double {
        return allReportsComputationTimes.reduce(reports[0].computationTime, combine: min)
    }
    var maximumReportsComputationTime : Double {
        return allReportsComputationTimes.reduce(reports[0].computationTime, combine: max)
    }

}
