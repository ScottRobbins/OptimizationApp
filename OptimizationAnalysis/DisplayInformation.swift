//
//  DisplayInformation.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/6/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class DisplayInformation {
    // Algorithm Enum
    enum Algorithm : String, Printable {
        case HillClimbing = "Hill Climbing"
        case SteepestAscentHillClimbing = "Steepest Ascent Hill Climbing"
        case SteepestAscentHillClimbingWithReplacement = "Steepest Ascent Hill Climbing With Replacement"
        case SteepestAscentHillClimbingWithRandomRestarts = "Steepest Ascent Hill Climbing With Random Restarts"
        case SimulatedAnnealing = "Simulated Annealing"
        case TabuSearch = "Tabu Search"
        
        static let allValues = [HillClimbing, SteepestAscentHillClimbing, SteepestAscentHillClimbingWithReplacement, SteepestAscentHillClimbingWithRandomRestarts, SimulatedAnnealing, TabuSearch]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    // Fit Function Enum
    enum FitFunction : String, Printable {
        case Sphere = "Sphere"
        case Rastrigin = "Rastrigin"
        case Griewank = "Griewank"
        case Rosenbrock = "Rosenbrock"
        
        static let allValues = [Sphere, Rastrigin, Griewank, Rosenbrock]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    // Parameter Enum
    enum Parameter : String, Printable {
        case Dimension = "Dimension"
        case Iterations = "Number of Iterations"
        case LowerBound = "Lower Bound"
        case UpperBound = "Upper Bound"
        case LowerChange = "Lower Change"
        case UpperChange = "Upper Change"
        case NumberOfTimesToRun = "Number of Times to Run"
        case NumberOfTweaks = "Number of Tweaks"
        case NumberOfRandomTimes = "Number of Random Times"
        case UpperBoundForRandomTimes = "Upper Bound For Random Times"
        case TempModifier = "Temporary Modifier"
        case MaxTabuListLength = "Max Tabu List Length"
        case RunNTimes = "Number of times to run"
        
        static let allValues = [Dimension, Iterations, LowerBound, UpperBound, LowerChange, UpperChange, NumberOfTimesToRun, NumberOfTweaks, NumberOfRandomTimes, UpperBoundForRandomTimes, TempModifier, MaxTabuListLength, RunNTimes]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }

    // Report Enum
    enum ReportDescriptions : String, Printable {
        case AlgorithmName = "Algorithm"
        case FitFunctionName = "Fit Function"
        case BestM = "Best M"
        case ComputationTime = "Computation Time"
        case Dimension = "Dimension"
        
        static let allValues = [AlgorithmName, FitFunctionName, BestM, ComputationTime, Dimension]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    // Average Report Enum
    enum AverageReportDescriptions : String, Printable {
        case AlgorithmName = "Algorithm"
        case FitFunctionName = "Fit Function"
        case AverageBestM = "Avg Best M"
        case AverageComputationTime = "Avg Computation Time"
        case StandardDeviationBestM = "Std Dev Best M"
        case StandardDeviationComputationTime = "Std Dev Computation Time"
        case Dimension = "Dimension"
        
        
        static let allValues = [AlgorithmName, FitFunctionName, AverageBestM, AverageComputationTime, StandardDeviationBestM, StandardDeviationComputationTime, Dimension]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    // Single Report Enum
    enum ReportGraph : String, Printable {
        case IterationVsBestM = "Iteration vs Best M"
        case ReportVsBestM = "Report vs Best M"
        case ReportVsComputationTime = "Report vs Computation Time"
        
        static let allValues = [IterationVsBestM, ReportVsBestM, ReportVsComputationTime]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    class func getParametersForAlgorithm(algorithm : Algorithm) -> Array<Parameter> {
        var parameters : Array<Parameter> = [.Dimension, .Iterations, .LowerBound, .UpperBound, .LowerChange, .UpperChange]
        
        switch algorithm {
        case .HillClimbing:
            break
        case .SteepestAscentHillClimbing:
            parameters.append(.NumberOfTweaks)
        case .SteepestAscentHillClimbingWithReplacement:
            parameters.append(.NumberOfTweaks)
        case .SteepestAscentHillClimbingWithRandomRestarts:
            parameters += [.NumberOfRandomTimes, .UpperBoundForRandomTimes]
        case .SimulatedAnnealing:
            parameters.append(.TempModifier)
        case .TabuSearch:
            parameters += [.NumberOfTweaks, .MaxTabuListLength]
        }
        
        parameters.append(.RunNTimes)
        
        return parameters
    }
    
    class func getReportGraphsForReportType(reportType : ReportType) -> [ReportGraph] {
        switch reportType {
        case .Single:
            return [ReportGraph.IterationVsBestM]
        case .Average:
            return [ReportGraph.IterationVsBestM, ReportGraph.ReportVsComputationTime]
        }
    }
}