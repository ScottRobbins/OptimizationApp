//
//  ParticalSwarmOptimization.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/7/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

class ParticalSwarm {
    class var description : String {
        get {
            return "Partical Swarm"
        }
    }
    
    class func particalSwarm(fitFunc : [Double] -> Double?,
        Nd : Int, // Number of Dimensions
        Nt : Int, // Number of Iterations
        Np : Int, // Number of Particles
        weight : Int, // weight
        lowerVelocity : Double, // Velocity Min
        upperVelocity : Double, // Velocity Max
        c1 : Double,   // Learning Factor
        c2 : Double,   // Learning Factor
        lowerBound : Int, // Lower Bound
        upperBound : Int, // Upper Bound
        getDataset : (Int, Int, Int, Int) -> [[Double]], // Np, Nd, lower bound, upper bound
        getVelocities : (Int, Int, Double, Double) -> [[Double]]) // Np, Nd, vMin, vMax
        -> Report?
    {
        var R : [[Double]] = getDataset(Np, Nd, lowerBound, upperBound)
        var V : [[Double]] = getVelocities(Np, Nd, lowerVelocity, upperVelocity)
        
        if R.isEmpty || R.count != Np || V.isEmpty { return nil }
        var M : [Double] = (0..<Np).map() { fitFunc(R[$0])! } // can unwrap because the only case of returning nil is if r is empty
        
        var report = Report()
        let phi = c1 + c2
        let chi = 2.0 / abs(2.0 - phi - sqrt(pow(phi, 2) - 4 * phi))
        var gBestValue = Double()
        if let temp = fitFunc(R[0]) {
            gBestValue = temp
        } else { return nil }
        var pBestValue = [Double](count: Np, repeatedValue: gBestValue)
        var gBestPos = [Double](count: Nd, repeatedValue: 0)
        var pBestPos =  [[Double]](count: Np, repeatedValue: gBestPos) // array of arrays of ints...because fuck you
        
        var computationStart = NSDate()
        for j in 0..<Nt {
            
            // Update the position
            for p in 0..<Np {
                for i in 0..<Nd {
                    R[p][i] = R[p][i] + V[p][i]
                    
                    R[p][i] = (R[p][i] > Double(upperBound)) ? Double(upperBound) : R[p][i]
                    R[p][i] = (R[p][i] < Double(lowerBound)) ? Double(lowerBound) : R[p][i]
                }
            }
            
            // Update Fitness
            for p in 0..<Np {
                if let temp = fitFunc(R[p]) {
                    M[p] = temp
                } else { return nil }
                
                if M[p] > gBestValue {
                    gBestValue = M[p]
                    gBestPos = R[p]
                }
                
                if M[p] > pBestValue[p] {
                    pBestValue[p] = M[p]
                    pBestPos[p] = R[p]
                }
            }
            
            // Update Velocity
            for p in 0..<Np {
                for i in 0..<Nd {
                    var r1 = Double(arc4random())
                    var r2 = Double(arc4random())
                    
                    // it was too long to put in one statement
                    var tempVal = Double(weight) * V[p][i] + r1 * Double(c1)
                    tempVal = tempVal * (pBestPos[p][i] - R[p][i]) + r2*Double(c2)
                    V[p][i] =  tempVal*(gBestPos[i] - R[p][i]) * chi
                    
                    V[p][i] = (V[p][i] > upperVelocity) ? upperVelocity : V[p][i]
                    V[p][i] = (V[p][i] < lowerVelocity) ? lowerVelocity : V[p][i]
                }
            }
            
            // Record Iteration
            report.iterations.append(Iteration(bestM: gBestValue))
        }
        
        report.bestM = gBestValue
        report.bestSolution = gBestPos
        report.algorithmName = DisplayInformation.DisplayAlgorithm.TabuSearch.description
        report.computationTime = computationStart.timeIntervalSinceNow * -1_000
        
        return report
    }
    
    class func particalSwarm(fitFunc : [Double] -> Double?,
        Nd : Int, // Number of Dimensions
        Nt : Int, // Number of Iterations
        Np : Int, // Number of Particles
        weight : Int, // Weight
        lowerVelocity : Double, // Velocity Min
        upperVelocity : Double, // Velocity Max
        c1 : Double,   // Learning Factor
        c2 : Double,   // Learning Factor
        lowerBound : Int, // Lower Bound
        upperBound : Int, // Upper Bound
        getDataset : (Int, Int, Int, Int) -> [[Double]], // Np, Nd, lower bound, upper bound
        getVelocities : (Int, Int, Double, Double) -> [[Double]], // Np, Nd, vMin, vMax
        runNTimes : Int)// R, lowerChange, upperChange, lowerBound, upperBound
        -> AverageReport?
    {
        var averageReport = AverageReport()
        var report = Report()
        var bestMArray = [Double]()
        var computationTimeArray = [Double]()
        var sumM = 0.0, sumComputationTime = 0.0, sumMStdDev = 0.0, sumComputationTimeStdDev = 0.0
        
        for _ in 0..<runNTimes {
            
            if let tempReport = particalSwarm(fitFunc, Nd: Nd, Nt: Nt, Np: Np, weight: weight, lowerVelocity: lowerVelocity, upperVelocity: upperVelocity, c1: c1, c2: c2, lowerBound: lowerBound, upperBound: upperBound, getDataset: getDataset, getVelocities: getVelocities) {
                
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