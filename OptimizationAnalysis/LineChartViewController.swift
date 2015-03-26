//
//  LineChartViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/18/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import JBChartView

class LineChartViewController: BaseChartViewController, JBLineChartViewDelegate, JBLineChartViewDataSource {

    // MARK: Declarations
    var singleReport : Report? = nil
    var averageReport : AverageReport? = nil
    var reportType = ReportType.Single // default
    
    @IBOutlet weak var lineChart: JBLineChartView!
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "\(singleReport!.algorithmName)"
        lineChart.delegate = self
        lineChart.dataSource = self
        chartView = lineChart
        
        // TODO: Assuming single report run, getting iterations will crash normally
        // find minimum
        var minimum = singleReport!.iterations[0].bestM
        var maximum = singleReport!.iterations[0].bestM
        for iteration in singleReport!.iterations {
            if minimum > iteration.bestM {
                minimum = iteration.bestM
            }
            
            if maximum < iteration.bestM {
                maximum = iteration.bestM
            }
        }
        
        lineChart.minimumValue = CGFloat(minimum)
        lineChart.maximumValue = CGFloat(maximum)
        lineChart.setState(.Collapsed, animated: false)
        
        var headerView = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 50.0))
        headerView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        headerView.textAlignment = .Center
        headerView.textColor = UIColor.whiteColor()
        headerView.text = "Iteration vs. BestM"
        self.lineChart.headerView = headerView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lineChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    // MARK: JBLineChartViewDataSource
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(singleReport!.iterations.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        var iteration = singleReport!.iterations[Int(horizontalIndex)]
        return CGFloat(iteration.bestM)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.lightGrayColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    // MARK: Helper Functions
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        if lineIndex == 0 {
            let data = singleReport!.iterations[Int(horizontalIndex)].bestM
            setToolTipVisible(true, animated: false, atTouchPoint: touchPoint)
            toolTipView.setText("\(horizontalIndex + 1) Best M: \(singleReport!.iterations[Int(horizontalIndex)].bestM)")
        }
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        self.setToolTipVisible(false, animated: true)
    }
    
    func hideChart() {
        lineChart.setState(.Collapsed, animated: true)
    }
    
    func showChart() {
        lineChart.setState(.Expanded, animated: true)
    }
    
    
}
