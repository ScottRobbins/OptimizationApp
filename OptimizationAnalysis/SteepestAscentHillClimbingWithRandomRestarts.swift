//
//  SteepestAscentHillClimbingWithRandomRestarts.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/1/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class SteepestAscentHillClimbingWithRandomRestarts {
    class var description : String {
        get {
            return "Steepest Ascent Hill Climbing With Random Restarts"
        }
    }
    
    class func steepestAscentHillClimbingWithRandomRestarts(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        randomTimes : [Double],
        getDataset : (Int, Int, Int) -> [Double], // should encompass some randomness
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?) // R, lowerChange, upperChange, lowerBound, upperBound
        -> Report?
    {
        var R = getDataset(Nd, lowerBound, upperBound)
        
        if R.isEmpty { return nil }
        
        var bestR = R
        var newR = [Double]()
        var report = Report()
        report.bestSolution = R
        if let temp = fitFunc(R) {
            report.bestM = temp
        } else { return nil }
        
        var totalTime = 0.0
        if let temp = Utils.avg(randomTimes) {
            totalTime = temp * Double(Nt) / 10.0
        } else { return nil }
        
        
        var computationStart = NSDate()
        while totalTime > 0 {
            var durationMS = randomTimes[Int(arc4random_uniform(UInt32(randomTimes.count)))]
            var beginTime = NSDate()
            totalTime -= durationMS
            
            while beginTime.timeIntervalSinceNow * -1000 < durationMS {
                if let temp = tweak(R, lowerChange, upperChange, lowerBound, upperBound) {
                    newR = temp
                } else { return nil }
                
                var tempNewR = 0.0, tempBestR = 0.0
                if let temp = fitFunc(newR) {
                    tempNewR = temp
                } else { return nil }
                
                if let temp = fitFunc(bestR) {
                    tempBestR = temp
                } else { return nil }
                
                if tempNewR > tempBestR {
                    R = newR
                }
            }
            
            var M = 0.0, newM = 0.0
            if let temp = fitFunc(R) {
                M = temp
            } else { return nil }
            
            if let temp = fitFunc(newR) {
                newM = temp
            } else { return nil }
            
            if (newM > M) {
                report.bestSolution = R
                report.bestM = newM
            }
            
            report.iterations.append(Iteration(bestM: report.bestM))
            
            // random restart
            R = getDataset(Nd, lowerBound, upperBound)
        }
        
        report.algorithmName = DisplayInformation.Algorithm.SteepestAscentHillClimbingWithRandomRestarts.description
        report.computationTime = computationStart.timeIntervalSinceNow * -1_000
        report.dimension = Nd
        
        return report
    }
    
    class func steepestAscentHillClimbingWithRandomRestarts(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        randomTimes : [Double],
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
            if let tempReport = steepestAscentHillClimbingWithRandomRestarts(fitFunc, Nd: Nd, Nt: Nt, lowerBound: lowerBound, upperBound: upperBound, lowerChange: lowerChange, upperChange: upperChange, randomTimes: randomTimes, getDataset: getDataset, tweak: tweak) {
                
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
