//
//  ApiAlgorithmManager.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation
import Alamofire

class ApiAlgorithmManager {

    // MARK: Public Declarations
    var apiAlgorithms : [Algorithm] {
        get {
            return self._apiAlgorithms
        }
    }
    
    // MARK: Private Declarations
    private var _apiAlgorithms = [Algorithm]()

    // MARK: Network Calls
    func getAlgorithms() {
        Alamofire.request(.GET, "http://andy.ampache.com:4900/algorithms", parameters: nil, encoding: .JSON)
        .responseJSON { (_, _, JSON, _) in
            self.parseAlgorithmJSON(JSON)
        }
    }
    
    // MARK: Parsing Functions
    private func parseAlgorithmJSON(JSON : AnyObject?) {
        var algs = [Algorithm]()
        if let algorithms = JSON as? [[String : Any]] {
            for algorithm in algorithms {
                if let id = algorithm["id"] as? String, let name = algorithm["name"] as? String, let params = algorithm["params"] as? [[String: String]] {
                    var alg = Algorithm(id: id, name: name)
                    var parameters = getParametersFromInput(params)
                    alg.setParameters(parameters)
                    algs.append(alg)
                }
            }
        }
        
        _apiAlgorithms = algs
    }
    
    private func getParametersFromInput(params : [[String: String]]) -> [Parameter] {
        var parameters = [Parameter]()
        for param in params {
            // TODO: Add in name when it exists
            if let ident = param["id"], let description = param["description"], let min = param["min"]?.doubleValue, let max = param["max"]?.doubleValue {
                parameters.append(Parameter(ident: ident, name: "", description: description, max: max, min: min))
            }
        }
        
        return parameters
    }
}