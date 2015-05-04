//
//  Algorithm.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//
//  NOTE: I'm forcing you to set stuff all at once because you're not trustworthy

import Foundation

class Algorithm {
    // MARK: Public Declarations
    var id : String {
        get {
            return self._id
        }
    }
    
    var name : String {
        get {
            return self._name
        }
    }
    
    var parameters : [Parameter] {
        get {
            return self._parameters
        }
    }
    
    var algorithmType : DisplayInformation.DisplayAlgorithm {
        get {
            return self._algorithmType
        }
    }
    
    
    // MARK: Private Declarations
    private var _id = String()
    private var _name = String()
    private var _parameters = [Parameter]()
    private var _algorithmType = DisplayInformation.DisplayAlgorithm.HillClimbing // default to hill climbing
    
    // MARK: Initializers
    init() {
        
    }
    
    convenience init(id : String, name : String, type : DisplayInformation.DisplayAlgorithm) {
        self.init()
        setAlgorithmDetails(id, name: name, type : type)
    }
    
    convenience init(id : String, name : String, type : DisplayInformation.DisplayAlgorithm, parameters : [Parameter]) {
        self.init(id: id, name: name, type : type)
        setParameters(parameters)
    }
    
    // MARK: Setter Functions
    func setAlgorithmDetails(id : String, name : String, type : DisplayInformation.DisplayAlgorithm) {
        _id = id
        _name = name
    }
    
    func setAlgorithmDetails(id : String, name : String, type : DisplayInformation.DisplayAlgorithm, parameters : [Parameter]) {
        setAlgorithmDetails(id, name: name, type : type)
        setParameters(parameters)
    }
    
    func setParameters(parameters : [Parameter]) {
        _parameters = parameters
    }
    
    func addParameter(parameter : Parameter) {
        _parameters.append(parameter)
    }
    
    func removeParameter(index : Int) {
        _parameters.removeAtIndex(index)
    }
    
    func removeAllParameters() {
        _parameters.removeAll(keepCapacity: false)
    }
    
}