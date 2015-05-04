//
//  Environment.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 4/21/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import Foundation

public enum EnvironmentResult {
    case Success(String)
    case Failure(String)
}

let kGetApiStringFailure = "Api string could not be retrieved"

class Environment {
    // MARK: Public Declarations
    class var apiString : EnvironmentResult {
        get {
            if let path = NSBundle.mainBundle().pathForResource("Environment", ofType: "plist") {
                if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                    // use swift dictionary as normal
                    if let apiDict = dict["ApiString"] as? [String : AnyObject] {
                        #if DEBUG
                            if let _apiString = apiDict["Debug"] as? String {
                                return .Success(_apiString)
                            } else { return .Failure(kGetApiStringFailure) }
                        #else
                            if let _apiString = apiDict["Distribution"] as? String {
                            return .Success(_apiString)
                            } else { return .Failure(kGetApiStringFailure) }
                        #endif
                    } else { return .Failure(kGetApiStringFailure) }
                } else { return .Failure(kGetApiStringFailure) }
            } else { return .Failure(kGetApiStringFailure) }
        }
    }
    
    
}