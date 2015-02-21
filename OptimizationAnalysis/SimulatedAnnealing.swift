//
//  SimulatedAnnealing.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/2/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class SimulatedAnnealing {
    
    class var description : String {
        get {
            return "Simulated Annealing"
        }
    }

    
    class func simulatedAnnealing(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        tempModifier : Int,
        getDataset : (Int, Int, Int) -> [Double], // should encompass some randomness
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?) // R, lowerChange, upperChange, lowerBound, upperBound
        -> Report?
    {
        var R = getDataset(Nd, lowerBound, upperBound)
        
        if R.isEmpty { return nil }
        
        var bestR = R
        var newR = [Double]()
        var report = Report()
        var t = tempModifier * (Int(arc4random_uniform(UInt32(46))) + 5) // 5-50
        var maxDuration = 200.0 // milliseconds
        
        var computationStart = NSDate()
        while computationStart.timeIntervalSinceNow * -1000.0 < maxDuration && t > 0 {
            if let temp = tweak(R, lowerChange, upperChange, lowerBound, upperBound) {
                newR = temp
            }
            
            var M = 0.0, newM = 0.0
            if let temp = fitFunc(R) {
                M = temp
            } else { return nil }
            
            if let temp = fitFunc(newR) {
                newM = temp
            } else { return nil }
            
            var tempMaxNum = pow(M_E, (newM - M) / Double(t))
            var randTempNum = Double(arc4random_uniform(UInt32(46))) / Double(UINT32_MAX) // double 0-1
            
            if newM > M || randTempNum < tempMaxNum {
                R = newR
            }
            
            t--
            
            if let temp = fitFunc(R) {
                M = temp
            } else { return nil }
            
            var bestM = 0.0
            if let temp = fitFunc(bestR) {
                bestM = temp
            } else { return nil }
            
            if M > bestM {
                bestR = R
                report.bestSolution = R
                report.bestM = newM
            }
        }
        
        report.algorithmName = DisplayInformation.Algorithm.SimulatedAnnealing.description
        report.computationTime = computationStart.timeIntervalSinceNow * -1_000
        report.dimension = Nd
        
        return report
    }
    
    class func simulatedAnnealing(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        tempModifier : Int,
        getDataset : (Int, Int, Int) -> [Double], // should encompass some randomness
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?, // R, lowerChange, upperChange, lowerBound, upperBound
        runNTimes : Int)
        -> AverageReport?
    {
        var averageReport = AverageReport()
        var report = Report()
        var bestMArray = [Double]()
        var computationTimeArray = [Double]()
        var sumM = 0.0, sumComputationTime = 0.0, sumMStdDev = 0.0, sumComputationTimeStdDev = 0.0
        
        for _ in 0..<runNTimes {
            if let tempReport = simulatedAnnealing(fitFunc, Nd: Nd, Nt: Nt, lowerBound: lowerBound, upperBound: upperBound, lowerChange: lowerChange, upperChange: upperChange, tempModifier: tempModifier, getDataset: getDataset, tweak: tweak) {
                
                report = tempReport
            } else { return nil }
            
            sumM += report.bestM
            bestMArray.append(report.bestM)
            sumComputationTime += report.computationTime
            computationTimeArray.append(report.computationTime)
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
