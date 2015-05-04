//
//  HillClimbing.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 1/31/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class HillClimbing {
    class var description : String {
        get {
            return "Hill Climbing"
        }
    }
    
    class func hillClimbing(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        getDataset : (Int, Int, Int) -> [Double],
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?) // R, lowerChange, upperChange, lowerBound, upperBound
        -> Report?
    {
        var R = getDataset(Nd, lowerBound, upperBound)
        
        if R.isEmpty { return nil }
        
        var newR = [Double]()
        var report = Report()
        report.bestSolution = R
        if let temp = fitFunc(R) {
            report.bestM = temp
        } else { return nil }
        
        var computationStart = NSDate()
        for _ in 0..<Nt {
        
            var tempR = [Double]()
            if let temp = tweak(R, lowerChange, upperChange, lowerBound, upperBound) {
                tempR = newR
                newR = temp
            } else { return nil }
            
            var M = 0.0, newM = 0.0
            
            if let temp = fitFunc(R) {
                M = temp
            } else { return nil }
            
            if let temp = fitFunc(newR) {
                newM = temp
            } else { return nil }
            
            if newM > M {
                R = newR
                report.bestSolution = newR
                report.bestM = newM
            }
            
            report.iterations.append(Iteration(bestM: report.bestM))
        }
        
        report.algorithmName = DisplayInformation.DisplayAlgorithm.HillClimbing.description
        report.computationTime = computationStart.timeIntervalSinceNow * -1_000
        report.dimension = Nd
        
        return report
    }
    
    class func hillClimbing(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        getDataset : (Int, Int, Int) -> [Double],
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?,
        runNTimes : Int)
        -> AverageReport?
    {
        var averageReport = AverageReport()
        var report = Report()
        var bestMArray = [Double]()
        var computationTimeArray = [Double]()
        var sumM = 0.0, sumComputationTime = 0.0, sumMStdDev = 0.0, sumComputationTimeStdDev = 0.0
        
        for _ in 0..<runNTimes {
            if let tempReport = hillClimbing(fitFunc, Nd: Nd, Nt: Nt, lowerBound: lowerBound, upperBound: upperBound, lowerChange: lowerChange, upperChange: upperChange, getDataset: getDataset, tweak: tweak) {
                report = tempReport
            } else { return nil }
            
            sumM += report.bestM
            bestMArray.append(report.bestM)
            sumComputationTime += report.computationTime
            computationTimeArray.append(report.computationTime)
            averageReport.reports.append(report)
        }
        
        averageReport.averageBestM = sumM / Double(runNTimes)
        averageReport.averageComputationTime = sumComputationTime / Double(runNTimes)
        averageReport.dimension = Nd
        averageReport.algorithmName = report.algorithmName
        averageReport.fitFunctionName = report.fitFunctionName // if there is one here, there probably isn't
        
        for bestM in bestMArray {
            sumMStdDev += pow(bestM - averageReport.averageBestM, 2.0)
        }
        averageReport.stdDevBestM = sqrt(sumMStdDev / Double(bestMArray.count))
        
        for computationTime in computationTimeArray {
            sumComputationTime += pow(computationTime - averageReport.averageComputationTime, 2.0)
        }
        averageReport.stdDevComputationTime = sqrt(sumComputationTime / Double(computationTimeArray.count))
        
        return averageReport
    }
}
