//
//  Utils.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/1/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//
//  Has some helper functions

import Foundation

public class Utils {
    
    class func avg<T: NumericType>(numberArray : [T]) -> T? {
        if numberArray.isEmpty { return nil }
        
        var sum : T = T(0)
        
        for num in numberArray {
            sum = sum + num
        }
        
        return sum / T(numberArray.count)
    }
    
}

// Used to make sure generic conforms to numeric property
protocol NumericType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Int)
}

// All of these ALREADY implement the numerictype functions of +, -, etc
// ...but at some point the compiler doesn't know it, so we explicitly state it
extension Double : NumericType {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self)
    }
}
extension Float  : NumericType {}
extension CGFloat : NumericType {}
extension Int    : NumericType {}
extension Int8   : NumericType {}
extension Int16  : NumericType {}
extension Int32  : NumericType {}
extension Int64  : NumericType {}
extension UInt   : NumericType {}
extension UInt8  : NumericType {}
extension UInt16 : NumericType {}
extension UInt32 : NumericType {}
extension UInt64 : NumericType {}

// Extension for arrays to be used as queues
extension Array {
    mutating func enQueue(var val : T) {
        self.append(val);
    }
    
    mutating func deQueue() -> T? {
        if self.isEmpty { return nil }
        
        var retVal = self.removeAtIndex(0)
        
        return retVal
    }
}