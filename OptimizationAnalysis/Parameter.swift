//
//  Parameter.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//
//  NOTE: I'm forcing you to set the parameters all at once so that you don't do something stupid

import Foundation

enum ParameterDataType {
    case Integer
    case Boolean
    case Float
}

class Parameter {
    
    // MARK: Public Declarations
    var ident : String? {
        get {
            return self._ident
        }
    }
    
    var name : String {
        get {
            return self._name
        }
    }
    
    var description: String? {
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
    
    var dataType : ParameterDataType {
        get {
            return self._dataType
        }
    }
    
    var value : AnyObject?
    
    // MARK: Private Declarations
    private var _ident = String()
    private var _name = String()
    private var _description : String?
    private var _max = Double()
    private var _min = Double()
    private var _dataType : ParameterDataType = .Integer // default Integer

    
    // MARK: Initializers
    init() {
        
    }
    
    convenience init(ident : String, name : String, description : String?, max : Double, min : Double, dataType : ParameterDataType) {
        self.init()
        setParameter(ident, name: name, description: description, max: max, min: min, dataType: dataType)
    }
    
    // MARK: Setter Functions
    func setParameter(ident : String, name : String, description : String?, max : Double, min : Double, dataType : ParameterDataType) {
        self._ident = ident
        self._name = name
        self._description = description
        self._max = max
        self._min = min
        self._dataType = dataType
    }
    
    class func getDataTypeForString(type : String) -> ParameterDataType {
        switch type {
        case "Integer":
            return .Integer
        case "Float":
            return .Float
        case "Boolean":
            return .Boolean
        default:
            return .Integer
        }
    }
    
}