//
//  AppAlgorithmManager.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/21/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class AppAlgorithmManager : AlgorithmManager {
    
    // MARK: Public Declarations
    override var algorithm : Algorithm {
        get {
            return self._algorithm
        }
        set {
            self._algorithm = newValue
            self._algorithm.setParameters(DisplayInformation.getParametersForAlgorithm(newValue.algorithmType))
        }
    }
    
    var fitFunction : FitFunction?
    var lastRunSingleReport : Report? = nil
    var lastRunMultipleReport : AverageReport? = nil
    
    // MARK: Private Declarations
    private var _algorithm = Algorithm()
    
    // MARK: Algorithm Methods
    func runAlgorithm() {
        var _runNTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.RunNTimes.description})
        var runNTimes: Int? = _runNTimes.count > 0 ? _runNTimes[0].value as? Int : nil

        if let tempRunNTimes = runNTimes {
            if tempRunNTimes == 1 {
                runAlgorithmSingleTime()
            } else {
                runAlgorithmMultipleTimes()
            }
        }
    }
    
    private func runAlgorithmSingleTime() {
        lastRunSingleReport = nil
        if fitFunction != nil {
            var fitFunc = getFitFunctionForFitFunction(fitFunction!.fitFunctionType)
            
            // This is a terrible way to do it, it makes me hurt, but I'm running out of time. lolsorrynotthatsorry
            var _Nd = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.Dimension.description})
            var _Nt = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.Iterations.description})
            var _lowerBound = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.LowerBound.description})
            var _upperBound = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperBound.description})
            var _lowerChange = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.LowerChange.description})
            var _upperChange = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperChange.description})
            var _lowerVelocity = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.lowerVelocity.description})
            var _upperVelocity = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.upperVelocity.description})
            var _numTweeks = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfTweaks.description})
            var _numRandTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfRandomTimes.description})
            var _numParticles = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfParticles.description})
            var _upperBoundRandTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperBoundForRandomTimes.description})
            var _tempModifier = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.TempModifier.description})
            var _weight = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.weight.description})
            var _c1 = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.learningFactor1.description})
            var _c2 = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.learningFactor2.description})
            var _maxTabuListLength = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.MaxTabuListLength.description})
            var _runNTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.RunNTimes.description})
            
            var Nd: Int? = _Nd.count > 0 ? _Nd[0].value as? Int : nil
            var Nt: Int? = _Nt.count > 0 ? _Nt[0].value as? Int : nil
            var lowerBound: Int? = _lowerBound.count > 0 ? _lowerBound[0].value as? Int : nil
            var upperBound: Int? = _upperBound.count > 0 ? _upperBound[0].value as? Int : nil
            var lowerChange: Int? = _lowerChange.count > 0 ? _lowerChange[0].value as? Int : nil
            var upperChange: Int? = _upperChange.count > 0 ? _upperChange[0].value as? Int : nil
            var lowerVelocity: Double? = _lowerVelocity.count > 0 ? _lowerVelocity[0].value as? Double : nil
            var upperVelocity: Double? = _upperVelocity.count > 0 ? _upperVelocity[0].value as? Double : nil
            var numTweaks: Int? = _numTweeks.count > 0 ? _numTweeks[0].value as? Int : nil
            var numRandTimes: Int? = _numRandTimes.count > 0 ? _numRandTimes[0].value as? Int : nil
            var numParticles: Int? = _numParticles.count > 0 ? _numParticles[0].value as? Int : nil
            var upperBoundRandTimes: Int? = _upperBoundRandTimes.count > 0 ? _upperBoundRandTimes[0].value as? Int : nil
            var tempModifier: Int? = _tempModifier.count > 0 ? _tempModifier[0].value as? Int : nil
            var weight: Int? = _weight.count > 0 ? _weight[0].value as? Int : nil
            var c1: Double? = _c1.count > 0 ? _c1[0].value as? Double : nil
            var c2: Double? = _c2.count > 0 ? _c2[0].value as? Double : nil
            var maxTabuListLength: Int? = _maxTabuListLength.count > 0 ? _maxTabuListLength[0].value as? Int : nil
            var runNTimes: Int? = _runNTimes.count > 0 ? _runNTimes[0].value as? Int : nil
            
            var report = Report?()
            switch algorithm.algorithmType {
            case .HillClimbing:
                report = HillClimbing.hillClimbing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
                
            case .SteepestAscentHillClimbing:
                report = SteepestAscentHillClimbing.steepestAscentHillClimbing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
                
            case .SteepestAscentHillClimbingWithReplacement:
                report = SteepestAscentHillClimbingWithReplacement.steepestAscentHillClimbingWithReplacement(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
                
            case .SteepestAscentHillClimbingWithRandomRestarts:
                let randomT = getRandomT(10, lowerBound: 0, upperBound: 0.5) // random times 0 - 0.5
                
                report = SteepestAscentHillClimbingWithRandomRestarts.steepestAscentHillClimbingWithRandomRestarts(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, randomTimes: randomT, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
                
            case .SimulatedAnnealing:
                report = SimulatedAnnealing.simulatedAnnealing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, tempModifier: tempModifier!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
                
            case .TabuSearch:
                report = TabuSearch.tabuSearch(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, maxTabuListLength: maxTabuListLength!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak)
            case .ParticalSwarm:
                report = ParticalSwarm.particalSwarm(fitFunc, Nd: Nd!, Nt: Nt!, Np: numParticles!, weight: weight!, lowerVelocity: lowerVelocity!, upperVelocity: upperVelocity!, c1: c1!, c2: c2!, lowerBound: lowerBound!, upperBound: upperBound!, getDataset: AppAlgorithmManager.getDatasetForPSO, getVelocities: AppAlgorithmManager.getVelocities)
            default:
                break
            }
            
            report?.fitFunctionName = fitFunction?.name
            lastRunSingleReport = report
            // send message back to delegate report is done
            delegate?.singleReportFinished(report)
        } else {
            delegate?.singleReportFinished(nil)
        }
    }
    
    private func runAlgorithmMultipleTimes() {
        lastRunMultipleReport = nil
        if fitFunction != nil {
            var fitFunc = getFitFunctionForFitFunction(fitFunction!.fitFunctionType)
            
            // This is a terrible way to do it, it makes me hurt, but I'm running out of time. lolsorrynotthatsorry
            var _Nd = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.Dimension.description})
            var _Nt = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.Iterations.description})
            var _lowerBound = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.LowerBound.description})
            var _upperBound = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperBound.description})
            var _lowerChange = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.LowerChange.description})
            var _upperChange = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperChange.description})
            var _lowerVelocity = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.lowerVelocity.description})
            var _upperVelocity = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.upperVelocity.description})
            var _numTweeks = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfTweaks.description})
            var _numRandTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfRandomTimes.description})
            var _numParticles = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.NumberOfParticles.description})
            var _upperBoundRandTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.UpperBoundForRandomTimes.description})
            var _tempModifier = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.TempModifier.description})
            var _weight = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.weight.description})
            var _c1 = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.learningFactor1.description})
            var _c2 = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.learningFactor2.description})
            var _maxTabuListLength = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.MaxTabuListLength.description})
            var _runNTimes = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.RunNTimes.description})
            
            var Nd: Int? = _Nd.count > 0 ? _Nd[0].value as? Int : nil
            var Nt: Int? = _Nt.count > 0 ? _Nt[0].value as? Int : nil
            var lowerBound: Int? = _lowerBound.count > 0 ? _lowerBound[0].value as? Int : nil
            var upperBound: Int? = _upperBound.count > 0 ? _upperBound[0].value as? Int : nil
            var lowerChange: Int? = _lowerChange.count > 0 ? _lowerChange[0].value as? Int : nil
            var upperChange: Int? = _upperChange.count > 0 ? _upperChange[0].value as? Int : nil
            var lowerVelocity: Double? = _lowerVelocity.count > 0 ? _lowerVelocity[0].value as? Double : nil
            var upperVelocity: Double? = _upperVelocity.count > 0 ? _upperVelocity[0].value as? Double : nil
            var numTweaks: Int? = _numTweeks.count > 0 ? _numTweeks[0].value as? Int : nil
            var numRandTimes: Int? = _numRandTimes.count > 0 ? _numRandTimes[0].value as? Int : nil
            var numParticles: Int? = _numParticles.count > 0 ? _numParticles[0].value as? Int : nil
            var upperBoundRandTimes: Int? = _upperBoundRandTimes.count > 0 ? _upperBoundRandTimes[0].value as? Int : nil
            var tempModifier: Int? = _tempModifier.count > 0 ? _tempModifier[0].value as? Int : nil
            var weight: Int? = _weight.count > 0 ? _weight[0].value as? Int : nil
            var c1: Double? = _c1.count > 0 ? _c1[0].value as? Double : nil
            var c2: Double? = _c2.count > 0 ? _c2[0].value as? Double : nil
            var maxTabuListLength: Int? = _maxTabuListLength.count > 0 ? _maxTabuListLength[0].value as? Int : nil
            var runNTimes: Int? = _runNTimes.count > 0 ? _runNTimes[0].value as? Int : nil
            
            var report = AverageReport?()
            switch algorithm.algorithmType {
            case .HillClimbing:
                report = HillClimbing.hillClimbing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
                
            case .SteepestAscentHillClimbing:
                report = SteepestAscentHillClimbing.steepestAscentHillClimbing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
                
            case .SteepestAscentHillClimbingWithReplacement:
                report = SteepestAscentHillClimbingWithReplacement.steepestAscentHillClimbingWithReplacement(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
                
            case .SteepestAscentHillClimbingWithRandomRestarts:
                let randomT = getRandomT(10, lowerBound: 0, upperBound: 0.5) // random times 0 - 0.5
                
                report = SteepestAscentHillClimbingWithRandomRestarts.steepestAscentHillClimbingWithRandomRestarts(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, randomTimes: randomT, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
                
            case .SimulatedAnnealing:
                report = SimulatedAnnealing.simulatedAnnealing(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, tempModifier: tempModifier!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
                
            case .TabuSearch:
                report = TabuSearch.tabuSearch(fitFunc, Nd: Nd!, Nt: Nt!, lowerBound: lowerBound!, upperBound: upperBound!, lowerChange: lowerChange!, upperChange: upperChange!, maxTabuListLength: maxTabuListLength!, numTweaks: numTweaks!, getDataset: AppAlgorithmManager.getDataset, tweak: AppAlgorithmManager.tweak, runNTimes: runNTimes!)
            case .ParticalSwarm:
                report = ParticalSwarm.particalSwarm(fitFunc, Nd: Nd!, Nt: Nt!, Np: numParticles!, weight: weight!, lowerVelocity: lowerVelocity!, upperVelocity: upperVelocity!, c1: c1!, c2: c2!, lowerBound: lowerBound!, upperBound: upperBound!, getDataset: AppAlgorithmManager.getDatasetForPSO, getVelocities: AppAlgorithmManager.getVelocities, runNTimes: runNTimes!)
                
            default:
                break
            }

                
                report?.fitFunctionName = fitFunction?.name
                lastRunMultipleReport = report
                // send message back to delegate report is done
                delegate?.multipleReportFinished(report)
        } else {
            delegate?.multipleReportFinished(nil)
        }
    }
    
    // MARK: Algorithm Helper Methods
    private func getFitFunctionForFitFunction(fitFunc : DisplayInformation.DisplayFitFunction) -> [Double] -> Double? {
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
    
    class func getDatasetForPSO(Np : Int, Nd : Int, lowerBound : Int, upperBound : Int) -> [[Double]] {
        var innerArray : [Double] = [Double]()
        var outerArray : [[Double]] = [[Double]]()
        for _ in 0..<Np {
            innerArray.removeAll(keepCapacity: false)
            for _ in 0..<Nd {
                innerArray.append(Double(lowerBound) + Double(arc4random()) / Double(UINT32_MAX) * Double(upperBound - lowerBound))
            }
            
            outerArray.append(innerArray)
        }
        
        return outerArray
    }
    
    class func getVelocities(Np : Int, Nd : Int, lowerVelocity : Double, upperVelocity : Double) -> [[Double]] {
        var innerArray : [Double] = [Double]()
        var outerArray : [[Double]] = [[Double]]()
        
        for _ in 0..<Np {
            innerArray.removeAll(keepCapacity: false)
            for _ in 0..<Nd {
                innerArray.append(lowerVelocity + Double(arc4random()) / Double(UINT32_MAX) * (upperVelocity - lowerVelocity))
            }
            
            outerArray.append(innerArray)
        }
        
        return outerArray
        
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