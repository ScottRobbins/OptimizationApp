//
//  AlgorithmManager.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

// MARK: Protocols
protocol AlgorithmManagerDelegate: class {
    func singleReportFinished(report : Report?)
    func multipleReportFinished(report : AverageReport?)
}

enum ReportType {
    case Single
    case Average
}

class AlgorithmManager {
    
    // MARK: Declarations
    private var _algorithm : DisplayInformation.Algorithm? = nil
    
    var algorithm : DisplayInformation.Algorithm? {
        get {
            return self._algorithm
        }
        set {
            self._algorithm = newValue
            self.parameters = newValue != nil ? DisplayInformation.getParametersForAlgorithm(newValue!) : nil
        }
    }
    
    var fitFunction : DisplayInformation.FitFunction? = nil
    var parameters : [DisplayInformation.Parameter]? = nil
    var delegate : AlgorithmManagerDelegate? = nil
    var lastRunSingleReport : Report? = nil
    var lastRunMultipleReport : AverageReport? = nil
    
    // MARK: Initializers
    init() {
        
    }
    
    // MARK: Algorithm Methods
    func runAlgorithmWithParameters(params : [Int]) {
        if let runNTimes = params.last {
            if runNTimes == 1 {
                runAlgorithmWithParametersSingleTime(params)
            } else {
                runAlgorithmWithParametersMultipleTimes(params)
            }
        }
    }
    
    private func runAlgorithmWithParametersSingleTime(params : [Int]) {
        lastRunSingleReport = nil
        if fitFunction != nil {
            var fitFunc = getFitFunctionForFitFunction(fitFunction!)
            
            var report = Report?()
            if params.count == parameters?.count {
                if let _algorithm = algorithm {
                    switch _algorithm {
                    case .HillClimbing:
                        report = HillClimbing.hillClimbing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    case .SteepestAscentHillClimbing:
                        report = SteepestAscentHillClimbing.steepestAscentHillClimbing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], numTweaks: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    case .SteepestAscentHillClimbingWithReplacement:
                        report = SteepestAscentHillClimbingWithReplacement.steepestAscentHillClimbingWithReplacement(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], numTweaks: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    case .SteepestAscentHillClimbingWithRandomRestarts:
                        let randomT = getRandomT(10, lowerBound: 0, upperBound: 0.5) // random times 0 - 0.5
                        
                        report = SteepestAscentHillClimbingWithRandomRestarts.steepestAscentHillClimbingWithRandomRestarts(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], randomTimes: randomT, getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    case .SimulatedAnnealing:
                        report = SimulatedAnnealing.simulatedAnnealing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], tempModifier: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    case .TabuSearch:
                        report = TabuSearch.tabuSearch(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], maxTabuListLength: params[6], numTweaks: params[7], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak)
                        
                    default:
                        break
                    }
                    
                    report?.fitFunctionName = fitFunction?.description
                    lastRunSingleReport = report
                    // send message back to delegate report is done
                    delegate?.singleReportFinished(report)
                }
            }
        } else {
            delegate?.singleReportFinished(nil)
        }
    }
    
    private func runAlgorithmWithParametersMultipleTimes(params : [Int]) {
        lastRunMultipleReport = nil
        if fitFunction != nil {
            var fitFunc = getFitFunctionForFitFunction(fitFunction!)
            
            var report = AverageReport?()
            if params.count == parameters?.count {
                if let _algorithm = algorithm {
                    switch _algorithm {
                    case .HillClimbing:
                        report = HillClimbing.hillClimbing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes: params[6])
                        
                    case .SteepestAscentHillClimbing:
                        report = SteepestAscentHillClimbing.steepestAscentHillClimbing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], numTweaks: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes : params[7])
                        
                    case .SteepestAscentHillClimbingWithReplacement:
                        report = SteepestAscentHillClimbingWithReplacement.steepestAscentHillClimbingWithReplacement(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], numTweaks: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes : params[7])
                        
                    case .SteepestAscentHillClimbingWithRandomRestarts:
                        let randomT = getRandomT(10, lowerBound: 0, upperBound: 0.5) // random times 0 - 0.5
                        
                        report = SteepestAscentHillClimbingWithRandomRestarts.steepestAscentHillClimbingWithRandomRestarts(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], randomTimes: randomT, getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes : params[6])
                        
                    case .SimulatedAnnealing:
                        report = SimulatedAnnealing.simulatedAnnealing(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], tempModifier: params[6], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes : params[7])
                        
                    case .TabuSearch:
                        report = TabuSearch.tabuSearch(fitFunc, Nd: params[0], Nt: params[1], lowerBound: params[2], upperBound: params[3], lowerChange: params[4], upperChange: params[5], maxTabuListLength: params[6], numTweaks: params[7], getDataset: AlgorithmManager.getDataset, tweak: AlgorithmManager.tweak, runNTimes : params[8])
                        
                    default:
                        break
                    }
                    
                    report?.fitFunctionName = fitFunction?.description
                    lastRunMultipleReport = report
                    // send message back to delegate report is done
                    delegate?.multipleReportFinished(report)
                }
            }
        } else {
            delegate?.multipleReportFinished(nil)
        }
    }
    
    // MARK: Algorithm Helper Methods
    private func getFitFunctionForFitFunction(fitFunc : DisplayInformation.FitFunction) -> [Double] -> Double? {
        switch fitFunc {
        case .Sphere:
            return FitFunctionManager.sphereFitFunctionWithValues
        case .Rosenbrock:
            return FitFunctionManager.rosenbrockFitFunctionWithValues
        case .Rastrigin:
            return FitFunctionManager.rastriginFitFunctionWithValues
        case .Griewank:
            return FitFunctionManager.griewankFitFunctionWithValues
        }
    }
    
    private func getRandomT(length : Int, lowerBound : Double, upperBound : Double) -> [Double] {
        var randomTimes = [Double]()
        
        for _ in 0..<length {
            var randomT = Double(arc4random()) / Double(UINT32_MAX)
            randomT = (randomT * (upperBound - lowerBound)) + lowerBound
            randomTimes.append(randomT)
        }
        
        return randomTimes
    }
    
    class func getDataset(Nd : Int, lowerBound : Int, upperBound : Int) -> [Double] {
        var R = [Double]()
        
        for _ in 0..<Nd {
            var tmp = Double(lowerBound) + ((Double(arc4random()) / Double(UINT32_MAX)) * Double(upperBound - lowerBound))
            R.append(tmp)
        }
        
        return R
    }
    
    class func tweak(R : [Double], lowerChange : Int, upperChange : Int, lowerBound : Int, upperBound : Int) -> [Double]? {
        var newR = [Double]()
        
        for r in R {
            var num = r
            if Double(arc4random()) / Double(UINT32_MAX) > 0.5 {
                num += (Double(arc4random()) / Double(UINT32_MAX)) * Double(upperChange - lowerChange)
                if num > Double(upperBound) || num < Double(lowerBound) {
                    num = Double(lowerBound) + ((Double(arc4random()) / Double(UINT32_MAX)) * Double(upperBound - lowerBound))
                }
            }
            newR.append(num)
        }
        
        return newR
    }
}