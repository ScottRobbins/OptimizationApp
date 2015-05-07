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
    enum DisplayAlgorithm : String, Printable {
        case HillClimbing = "Hill Climbing"
        case SteepestAscentHillClimbing = "Steepest Ascent Hill Climbing"
        case SteepestAscentHillClimbingWithReplacement = "Steepest Ascent Hill Climbing With Replacement"
        case SteepestAscentHillClimbingWithRandomRestarts = "Steepest Ascent Hill Climbing With Random Restarts"
        case SimulatedAnnealing = "Simulated Annealing"
        case TabuSearch = "Tabu Search"
        case ParticalSwarm = "Partical Swarm"
        
        static let allValues = [HillClimbing, SteepestAscentHillClimbing, SteepestAscentHillClimbingWithReplacement, SteepestAscentHillClimbingWithRandomRestarts, SimulatedAnnealing, TabuSearch, ParticalSwarm]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    enum DisplayAlgorithmIdent : String, Printable {
        case HillClimbing = "hillClimb"
        case SteepestAscentHillClimbing = "steepestAscent"
        case SteepestAscentHillClimbingWithReplacement = "steepestAscentWithReplacement"
        case SteepestAscentHillClimbingWithRandomRestarts = "steepestAscentWithRandomRestarts"
        case SimulatedAnnealing = "simulatedAnnealing"
        case TabuSearch = "tabuSearch"
        case ParticalSwarm = "particalSwarm"
        
        static let allValues = [HillClimbing, SteepestAscentHillClimbing, SteepestAscentHillClimbingWithReplacement, SteepestAscentHillClimbingWithRandomRestarts, SimulatedAnnealing, TabuSearch, ParticalSwarm]
        
        var description : String {
            get {
                return self.rawValue
            }
        }

    }
    
    // Fit Function Enum
    enum DisplayFitFunction : String, Printable {
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
    
    enum DisplayFitFunctionIdent : String, Printable {
        case Sphere = "sphere"
        case Rastrigin = "rastrigin"
        case Griewank = "griewank"
        case Rosenbrock = "rosenbrock"
        
        static let allValues = [Sphere, Rastrigin, Griewank, Rosenbrock]
        
        var description : String {
            get {
                return self.rawValue
            }
        }

    }
    
    // Parameter Enum
    enum DisplayParameter : String, Printable {
        case Dimension = "Dimension"
        case Iterations = "Number of Iterations"
        case LowerBound = "Lower Bound"
        case UpperBound = "Upper Bound"
        case LowerChange = "Lower Change"
        case UpperChange = "Upper Change"
        case lowerVelocity = "Lower Velocity"
        case upperVelocity = "Upper Velocity"
        case NumberOfTweaks = "Number of Tweaks"
        case NumberOfParticles = "Number of Particles"
        case TempModifier = "Temporary Modifier"
        case weight = "Weight"
        case learningFactor1 = "Learning Factor 1"
        case learningFactor2 = "Learning Factory 2"
        case RunNTimes = "Number of times to run"
        
        static let allValues = [Dimension, Iterations, LowerBound, UpperBound, LowerChange, UpperChange, lowerVelocity, upperVelocity, NumberOfTweaks, NumberOfParticles, TempModifier, weight, RunNTimes]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    enum DisplayParameterIdent : String, Printable {
        case Dimension = "dimension"
        case Iterations = "iterations"
        case LowerBound = "lBound"
        case UpperBound = "uBound"
        case LowerChange = "lChange"
        case UpperChange = "uChange"
        case lowerVelocity = "minVelocity"
        case upperVelocity = "maxVelocity"
        case NumberOfTweaks = "numTweaks"
        case NumberOfParticles = "numParticles"
        case TempModifier = "tempModifier"
        case weight = "inertiaWeight"
        case learningFactor1 = "cognitiveWeight"
        case learningFactor2 = "socialWeight"
        case RunNTimes = "numRuns"
        
        static let allValues = [Dimension, Iterations, LowerBound, UpperBound, LowerChange, UpperChange, lowerVelocity, upperVelocity, NumberOfTweaks, NumberOfParticles, TempModifier, weight, RunNTimes]
        
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
        
        static let allValues = [AlgorithmName, FitFunctionName, BestM, ComputationTime]
        
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
        
        
        static let allValues = [AlgorithmName, FitFunctionName, AverageBestM, AverageComputationTime, StandardDeviationBestM, StandardDeviationComputationTime]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }
    
    // Average Report Enum
    enum ApiReportDescriptions : String, Printable {
        case AlgorithmName = "Algorithm"
        case FitFunctionName = "Fit Function"
        case AverageBestM = "Avg Best M"
        case AverageComputationTime = "Avg Computation Time"
        case StandardDeviationBestM = "Std Dev Best M"
        case StandardDeviationComputationTime = "Std Dev Computation Time"
        case RoundTripTime = "Round Trip Time"
        
        
        static let allValues = [AlgorithmName, FitFunctionName, AverageBestM, AverageComputationTime, StandardDeviationBestM, StandardDeviationComputationTime, RoundTripTime]
        
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
    
    // Axis Labels Enum
    enum AxisLabel : String, Printable {
        case Iteration = "Iteration"
        case BestM = "Best M"
        case Report = "Report"
        case ComputationTime = "Computation Time"
        
        static let allValues = [Iteration, BestM, Report, ComputationTime]
        
        var description : String {
            get {
                return self.rawValue
            }
        }
    }

    class func getParametersForAlgorithm(algorithmType : DisplayAlgorithm) -> [Parameter] {
        var parameters : [DisplayParameter] = [.Dimension, .Iterations, .LowerBound, .UpperBound]
        
        switch algorithmType {
        case .HillClimbing:
            parameters += [.LowerChange, .UpperChange]
        case .SteepestAscentHillClimbing:
            parameters += [.LowerChange, .UpperChange, .NumberOfTweaks]
        case .SteepestAscentHillClimbingWithReplacement:
            parameters += [.LowerChange, .UpperChange, .NumberOfTweaks]
        case .SteepestAscentHillClimbingWithRandomRestarts:
            parameters += [.LowerChange, .UpperChange]
        case .SimulatedAnnealing:
            parameters += [.LowerChange, .UpperChange, .TempModifier]
        case .TabuSearch:
            parameters += [.LowerChange, .UpperChange, .NumberOfTweaks]
        case .ParticalSwarm:
            parameters += [.NumberOfParticles, .lowerVelocity, .upperVelocity, .weight, .learningFactor1, .learningFactor2]
        }
        
        parameters.append(.RunNTimes)
        
        return parameters.map({ DisplayInformation.constructParameter($0)})
    }
    
    class func constructParameter(displayParameter : DisplayParameter) -> Parameter {
        switch displayParameter {
        case .Dimension:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.Dimension.description, name: displayParameter.description, description: nil, max: 100, min: 1, dataType: .Integer)
        case .Iterations:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.Iterations.description, name: displayParameter.description, description: nil, max: 1000, min: 1, dataType: .Integer)
        case .LowerBound:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.LowerBound.description, name: displayParameter.description, description: nil, max: 0, min: -100, dataType: .Integer)
        case .UpperBound:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.UpperBound.description, name: displayParameter.description, description: nil, max: 100, min: 0, dataType: .Integer)
        case .LowerChange:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.LowerChange.description, name: displayParameter.description, description: nil, max: 0, min: -10, dataType: .Integer)
        case .UpperChange:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.UpperChange.description, name: displayParameter.description, description: nil, max: 10, min: 0, dataType: .Integer)
        case .lowerVelocity:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.lowerVelocity.description, name: displayParameter.description, description: nil, max: -0.01, min: -100.0, dataType: .Float)
        case .upperVelocity:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.upperVelocity.description, name: displayParameter.description, description: nil, max: 1000, min: 0, dataType: .Float)
        case .NumberOfTweaks:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.NumberOfTweaks.description, name: displayParameter.description, description: nil, max: 10, min: 0, dataType: .Integer)
        case .NumberOfParticles:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.NumberOfParticles.description, name: displayParameter.description, description: nil, max: 1000, min: 1, dataType: .Integer)
        case .TempModifier:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.TempModifier.description, name: displayParameter.description, description: nil, max: 100, min: -100, dataType: .Float)
        case .weight:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.weight.description, name: displayParameter.description, description: nil, max: 1000, min: 0, dataType: .Float)
        case .learningFactor1:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.learningFactor1.description, name: displayParameter.description, description: nil, max: 1000, min: 0, dataType: .Float)
        case .learningFactor2:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.learningFactor2.description, name: displayParameter.description, description: nil, max: 1000, min: 0, dataType: .Float) 
        case .RunNTimes:
            return Parameter(ident: DisplayInformation.DisplayParameterIdent.RunNTimes.description, name: displayParameter.description, description: nil, max: 1000, min: 1, dataType: .Integer)
        }
    }
    
    class func constructAlgorithm(displayAlgorithm : DisplayAlgorithm) -> Algorithm {
        switch displayAlgorithm { 
        case .HillClimbing:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.HillClimbing.description, name: displayAlgorithm.description, type: .HillClimbing)
        case .SteepestAscentHillClimbing:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.SteepestAscentHillClimbing.description, name: displayAlgorithm.description, type: .SteepestAscentHillClimbing)
        case .SteepestAscentHillClimbingWithReplacement:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.SteepestAscentHillClimbingWithReplacement.description, name: displayAlgorithm.description, type: .SteepestAscentHillClimbingWithReplacement)
        case .SteepestAscentHillClimbingWithRandomRestarts:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.SteepestAscentHillClimbingWithRandomRestarts.description, name: displayAlgorithm.description, type: .SteepestAscentHillClimbingWithRandomRestarts)
        case .SimulatedAnnealing:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.SimulatedAnnealing.description, name: displayAlgorithm.description, type: .SimulatedAnnealing)
        case .TabuSearch:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.TabuSearch.description, name: displayAlgorithm.description, type: .TabuSearch)
        case .ParticalSwarm:
            return Algorithm(id: DisplayInformation.DisplayAlgorithmIdent.ParticalSwarm.description, name: displayAlgorithm.description, type: .ParticalSwarm)
        }
    }
    
    class func constructFitFunction(displayFitFunction : DisplayFitFunction) -> FitFunction {
        switch displayFitFunction {
        case .Sphere:
            return FitFunction(id: DisplayInformation.DisplayFitFunctionIdent.Sphere.description, name: displayFitFunction.description, fitFunctionType : displayFitFunction)
        case .Rastrigin:
            return FitFunction(id: DisplayInformation.DisplayFitFunctionIdent.Rastrigin.description, name: displayFitFunction.description, fitFunctionType : displayFitFunction)
        case .Griewank:
            return FitFunction(id: DisplayInformation.DisplayFitFunctionIdent.Griewank.description, name: displayFitFunction.description, fitFunctionType : displayFitFunction)
        case .Rosenbrock:
            return FitFunction(id: DisplayInformation.DisplayFitFunctionIdent.Rosenbrock.description, name: displayFitFunction.description, fitFunctionType : displayFitFunction)
        }
    }
        
    class func getReportGraphsForReportType(reportType : ReportType) -> [ReportGraph]? {
        switch reportType {
        case .Single:
            return [ReportGraph.IterationVsBestM]
        case .Average:
            return [ReportGraph.ReportVsBestM, ReportGraph.ReportVsComputationTime]
        case .Api:
            return nil
        }
    }
}