//
//  DisplayInformation.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/6/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class DisplayInformation {
    // Fit Function Enum
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
}