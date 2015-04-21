//
//  Parameter.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//
//  NOTE: I'm forcing you to set the parameters all at once so that you don't do something stupid

import Foundation

class Parameter {
    
    // MARK: Public Declarations
    var ident : String {
        get {
            return self._ident
        }
    }
    
    var name : String {
        get {
            return self._name
        }
    }
    
    var description: String {
        get {
            return self._description
        }
    }
    
    var max : Double {
        get {
            return self._max
        }
    }
    
    var min : Double {
        get {
            return self._min
        }
    }
    
    // MARK: Private Declarations
    private var _ident = String()
    private var _name = String()
    private var _description = String()
    private var _max = Double()
    private var _min = Double()
    
    // MARK: Initializers
    init() {
        
    }
    
    convenience init(ident : String, name : String, description : String, max : Double, min : Double) {
        self.init()
        setParameter(ident, name: name, description: description, max: max, min: min)
    }
    
    // MARK: Setter Functions
    func setParameter(ident : String, name : String, description : String, max : Double, min : Double) {
        self._ident = ident
        self._name = name
        self._description = description
        self._max = max
        self._min = min
    }
    
    
}