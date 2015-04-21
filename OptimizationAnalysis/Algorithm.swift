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
    
    // MARK: Private Declarations
    private var _id = String()
    private var _name = String()
    private var _parameters = [Parameter]()
    
    // MARK: Initializers
    init() {
        
    }
    
    convenience init(id : String, name : String) {
        self.init()
        setAlgorithmDetails(id, name: name)
    }
    
    convenience init(id : String, name : String, parameters : [Parameter]) {
        self.init(id: id, name: name)
        setParameters(parameters)
    }
    
    // MARK: Setter Functions
    func setAlgorithmDetails(id : String, name : String) {
        _id = id
        _name = name
    }
    
    func setAlgorithmDetails(id : String, name : String, parameters : [Parameter]) {
        setAlgorithmDetails(id, name: name)
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