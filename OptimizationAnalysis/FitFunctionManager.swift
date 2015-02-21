//
//  FitFunctionManager.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 1/31/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

class FitFunctionManager {
    
    class func sphereFitFunctionWithValues(xVals : [Double]) -> Double? {
        if xVals.isEmpty { return nil }
        
        var retVal = 0.0
        
        for x in xVals {
            retVal += pow(x, 2.0)
        }
        
        return retVal
    }
    
    class func rastriginFitFunctionWithValues(xVals : [Double]) -> Double? {
        if xVals.isEmpty { return nil }
        
        var retVal = 10.0 * Double(xVals.count)
        
        for x in xVals {
            retVal += pow(x, 2.0) - 10.0 * cos(2.0 * M_PI * x) + 10.0
        }
        
        return retVal
    }
    
    class func griewankFitFunctionWithValues(xVals : [Double]) -> Double? {
        if xVals.isEmpty { return nil }
        
        var retVal = 0.0
        var sum = 0.0
        var product = 0.0
        
        for (i, x) in enumerate(xVals) {
            sum += pow(x, 2.0) / 40_000.0
            if i == 0 {
                product = cos(x / sqrt(Double(i) + 1.0))
            } else {
                product *= cos(x / sqrt(Double(i) + 1.0))
            }
        }
        
        retVal = 1.0 + sum - product
        
        return retVal
    }
    
    class func rosenbrockFitFunctionWithValues(xVals : [Double]) -> Double? {
        if xVals.isEmpty { return nil }
        
        var retVal = 0.0
        
        for i in 0..<(xVals.count - 1) {
            retVal += pow(1.0 - xVals[i], 2.0) + 100 * pow(xVals[i+1] - pow(xVals[i], 2.0), 2.0)
        }
        
        return retVal
    }
    
}

