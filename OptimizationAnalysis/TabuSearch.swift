//
//  TabuSearch.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/3/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class TabuSearch {
    class var description : String {
        get {
            return "Tabu Search"
        }
    }
    
    class func tabuSearch(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        maxTabuListLength : Int,
        numTweaks : Int,
        getDataset : (Int, Int, Int) -> [Double], // should encompass some randomness
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?) // R, lowerChange, upperChange, lowerBound, upperBound
        -> Report?
    {
        var R = getDataset(Nd, lowerBound, upperBound)
        
        if R.isEmpty { return nil }
        
        var bestR = R
        var newR = [Double]()
        var newW = [Double]()
        var report = Report()
        var tabuList = [Double]()
        var newM = 0.0, wM = 0.0, M = 0.0, bestM = 0.0
        
        for r in R {
            tabuList.enQueue(r)
        }
        
        var computationStart = NSDate()
        for _ in 0..<Nt {
            if tabuList.count > maxTabuListLength {
                tabuList.deQueue()
            }
            
            if let temp = tweak(R, lowerChange, upperChange, lowerBound, upperBound) {
                newR = temp
            } else { return nil }
            
            for _ in 0..<(numTweaks - 1) {
                if let temp = tweak(R, lowerChange, upperChange, lowerBound, upperBound) {
                    newW = temp
                } else { return nil }
                
                if let temp = fitFunc(newR) {
                    newM = temp
                } else { return nil }
                
                if let temp = fitFunc(newW) {
                    wM = temp
                } else { return nil }
                
                // You are here
                if !NSSet(array: newW).isEqualToSet(NSSet(array: tabuList)) && (wM > newM || NSSet(array: newR).isEqualToSet(NSSet(array: tabuList))) {
                    newR = newW
                    newM = wM
                }
            }
            
            if !NSSet(array: newR).isEqualToSet(NSSet(array: tabuList)) && newM > M {
                R = newR
                M = newM
                
                // enQueue newR into tabuList
                for r in newR {
                    tabuList.enQueue(r)
                    if tabuList.count > maxTabuListLength {
                        tabuList.deQueue()
                    }
                }
            }
            
            if let temp = fitFunc(bestR) {
                bestM = temp
            }
            
            if M > bestM {
                bestR = R
                bestM = M
                report.bestSolution = bestR
                report.bestM = bestM
            }
        }
        
        report.algorithmName = DisplayInformation.Algorithm.TabuSearch.description
        report.computationTime = computationStart.timeIntervalSinceNow * -1_000
        report.dimension = Nd
        
        return report
    }
    
    class func tabuSearch(fitFunc : [Double] -> Double?,
        Nd : Int,
        Nt : Int,
        lowerBound : Int,
        upperBound : Int,
        lowerChange : Int,
        upperChange : Int,
        maxTabuListLength : Int,
        numTweaks : Int,
        getDataset : (Int, Int, Int) -> [Double], // should encompass some randomness
        tweak : ([Double], Int, Int, Int, Int) -> [Double]?,
        runNTimes : Int) // R, lowerChange, upperChange, lowerBound, upperBound
        -> AverageReport?
    {
        var averageReport = AverageReport()
        var report = Report()
        var bestMArray = [Double]()
        var computationTimeArray = [Double]()
        var sumM = 0.0, sumComputationTime = 0.0, sumMStdDev = 0.0, sumComputationTimeStdDev = 0.0
        
        for _ in 0..<runNTimes {
            if let tempReport = tabuSearch(fitFunc, Nd: Nd, Nt: Nt, lowerBound: lowerBound, upperBound: upperBound, lowerChange: lowerChange, upperChange: upperChange, maxTabuListLength: maxTabuListLength, numTweaks: numTweaks, getDataset: getDataset, tweak: tweak) {
                
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