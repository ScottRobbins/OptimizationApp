//
//  ApiAlgorithmManager.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Protocols
protocol ApiAlgorithmManagerDelegate: class {
    func apiReportFinished(report : ApiReport?)
}

class ApiAlgorithmManager : AlgorithmManager {

    // MARK: Public Declarations
    var apiAlgorithms : [Algorithm] {
        get {
            return self._apiAlgorithms
        }
    }
    
    var apiFitFunctions : [FitFunction] {
        get {
            return self._apiFitFunctions
        }
    }
    
    var fitFunction = FitFunction()
    var lastRunApiReport : ApiReport?
    var delegate : ApiAlgorithmManagerDelegate?
    
    // MARK: Private Declarations
    private var _apiAlgorithms = [Algorithm]()
    private var _apiFitFunctions = [FitFunction]()
    

    // MARK: Network Calls
    func getAlgorithms() {
        let _apiString = Environment.apiString
        
        switch _apiString {
        case .Success(let apiString):
            Alamofire.request(.GET, "\(apiString)/algorithms", parameters: nil, encoding: .JSON)
                .responseJSON { (_, _, JSON, _) in
                    self.parseAlgorithmJSON(JSON)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kAlgorithmsHaveUpdated, object: nil))
            }
        case .Failure(let exception):
            // Programming error: Danger Will Robinson, Danger!
            NSException(name: "Api String Not Found Exception", reason: "Api string could not be found in plist", userInfo: nil).raise()
        }
    }
    
    func getFitFunctions() {
        let _apiString = Environment.apiString
        
        switch _apiString {
        case .Success(let apiString):
            Alamofire.request(.GET, "\(apiString)/fitness", parameters: nil, encoding: .JSON)
                .responseJSON { (_, _, JSON, _) in
                    self.parseFitFunctionJSON(JSON)
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: kFitFunctionsHaveUpdated, object: nil))
            }
        case .Failure(let exception):
            // Programming error: Danger Will Robinson, Danger!
            NSException(name: "Api String Not Found Exception", reason: "Api string could not be found in plist", userInfo: nil).raise()
        }

    }
    
    // MARK: Parsing Functions
    private func parseAlgorithmJSON(JSON : AnyObject?) {
        var algs = [Algorithm]()
        if let algorithms = JSON as? [[String : AnyObject]] {
            for algorithm in algorithms {
                if let id = algorithm["id"] as? String, let name = algorithm["name"] as? String, let params = algorithm["params"] as? [[String: AnyObject]] {
                    if let _algorithmType = getAlgorithmTypeForString(id) {
                        var alg = Algorithm(id: id, name: name, type: _algorithmType) // api doesn't need to set type
                        var parameters = getParametersFromInput(params)
                        alg.setParameters(parameters)
                        algs.append(alg)
                    }
                }
            }
        }
        
        _apiAlgorithms = algs
    }
    
    private func parseFitFunctionJSON(JSON : AnyObject?) {
        var fitFuncs = [FitFunction]()
        if let fitFunctions = JSON as? [[String : String]] {
            for fitFunction in fitFunctions {
                if let id = fitFunction["id"], let name = fitFunction["name"] {
                    if let _fitFunc = getFitFunctionTypeForString(id) {
                        var fitFunc = FitFunction(id: id, name: name, fitFunctionType: _fitFunc)
                        fitFuncs.append(fitFunc)
                    }
                }
            }
        }
        
        _apiFitFunctions = fitFuncs
    }
    
    private func getParametersFromInput(params : [[String: AnyObject]]) -> [Parameter] {
        var parameters = [Parameter]()
        for param in params {
            if let ident = param["id"] as? String, let name = param["name"] as? String, let description = param["description"] as? String, let min = param["min"] as? Int, let max = param["max"] as? Int, let type = param["type"] as? String {
                parameters.append(Parameter(ident: ident, name: name, description: description, max: Double(max), min: Double(min), dataType: Parameter.getDataTypeForString(type)))
            }
        }
        
        return parameters
    }
    
    // MARK: Algorithm Methods
    func runAlgorithm() {
        let _apiString = Environment.apiString
        let parameters = buildParametersJSONForAlgorithm()
        if let numRuns = algorithm.parameters.filter({$0.ident == DisplayInformation.DisplayParameterIdent.RunNTimes.description})[0].value as? Int {
            switch _apiString {
            case .Success(let apiString):
                var startTime = NSDate()
                Alamofire.request(.POST, "\(apiString)/execute", parameters: parameters, encoding: .JSON)
                    .responseJSON { (_, _, JSON, _) in
                        self.lastRunApiReport = self.parseAlgorithmResponseJSON(JSON, numRuns: numRuns)
                        self.lastRunApiReport?.roundTripTime = startTime.timeIntervalSinceNow * -1_000
                        self.delegate?.apiReportFinished(self.lastRunApiReport)
                }
            case .Failure(let exception):
                // Programming error: Danger Will Robinson, Danger!
                NSException(name: "Api String Not Found Exception", reason: "Api string could not be found in plist", userInfo: nil).raise()
            }
        }
    }
    
    private func buildParametersJSONForAlgorithm() -> [String : AnyObject] {
        var jsonDict = [String : AnyObject]()
        
        jsonDict["algorithm"] = algorithm.id
        jsonDict["fitnessFunction"] = fitFunction.id
        
        var parameterJSONDict = [String : AnyObject]()
        for parameter in algorithm.parameters {
            if let ident = parameter.ident {
                parameterJSONDict[ident] = parameter.value
            }
        }
        
        parameterJSONDict["isMaxObj"] = true
        jsonDict["parameters"] = parameterJSONDict
        
        return jsonDict
    }
    
    private func parseAlgorithmResponseJSON(JSON : AnyObject?, numRuns : Int) -> ApiReport? {
        var report = ApiReport()
        if let resultDict = JSON as? [String : AnyObject] {
            if let algorithmName = resultDict["algorithm"] as? String, let fitnessFunction = resultDict["fitnessFunction"] as? String, result = resultDict["result"] as? [String : Double] {
                report.algorithmName = algorithmName
                report.fitFunctionName = fitnessFunction
                
                if let bestM = result["averageSolution"], let averageTime = result["averageTime"], let solutionStdDev = result["solutionStdDev"], let timeStdDev = result["timeStdDev"] {
                    report.bestM = bestM
                    report.computationTime = averageTime
                    report.stdDevBestM = solutionStdDev
                    report.stdDevComputationTime = timeStdDev
                    
                    return report
                }
            }
        }
        
        return nil
    }
    
    private func getAlgorithmTypeForString(idString : String) -> DisplayInformation.DisplayAlgorithm? {
        switch idString {
        case "hillClimb":
            return .HillClimbing
        case "steepestAscent":
            return .SteepestAscentHillClimbing
        case "steepestAscentWithReplacement":
            return .SteepestAscentHillClimbingWithReplacement
        case "steepestAscentHillClimbingWithRandomRestarts":
            return .SteepestAscentHillClimbingWithRandomRestarts
        case "simulatedAnnealing":
            return .SimulatedAnnealing
        case "tabuSearch":
            return .TabuSearch
        case "particleSwarm":
            return .ParticalSwarm
        default:
            return nil
        }
    }
    
    private func getFitFunctionTypeForString(fitFuncId : String) -> DisplayInformation.DisplayFitFunction? {
        switch fitFuncId {
        case "sphere":
            return .Sphere
        case "rastrigin":
            return .Rastrigin
        case "griewank":
            return .Griewank
        case "rosenbrock":
            return .Rosenbrock
        default:
            return nil
        }
    }
}