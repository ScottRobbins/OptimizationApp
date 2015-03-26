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
    // MARK: Declarations
    var singleReport : Report? = nil
    var averageReport : AverageReport? = nil
    var reportType = ReportType.Single // default
    
    @IBOutlet weak var barChart: JBBarChartView!
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        barChart.delegate = self
//        barChart.dataSource = self
    }

    
}
