//
//  FitFunction.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/28/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class FitFunction {
    
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
    
    var fitFunctionType : DisplayInformation.DisplayFitFunction {
        get {
            return self._fitFunctionType
        }
    }
    
    // MARK: Private Declarations
    private var _id = String()
    private var _name = String()
    private var _fitFunctionType = DisplayInformation.DisplayFitFunction.Sphere

    // MARK: Initializers
    init() {
        
    }
    
    convenience init(id : String, name : String, fitFunctionType : DisplayInformation.DisplayFitFunction) {
        self.init()
        _id = id
        _name = name
        _fitFunctionType = fitFunctionType
    }
}