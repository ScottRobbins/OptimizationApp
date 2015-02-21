//
//  BarChartViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 2/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import JBChartView

class BarChartViewController: UIViewController {
    var xValues : [String]? = nil
    var yValues : [Double]? = nil
    
    @IBOutlet weak var barChart: JBBarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
}
