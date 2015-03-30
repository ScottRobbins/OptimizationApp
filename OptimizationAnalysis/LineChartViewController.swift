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

    // MARK: Public Declarations
    var minimumY : Double?
    var maximumY : Double?
    var graphTitle : String?
    
    // MARK: Private Declarations
    private var lines = Dictionary<String, [Double]>()
    private var linesNextId = 0
    
    @IBOutlet weak var lineChart: JBLineChartView!
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lineChart.delegate = self
        lineChart.dataSource = self
        chartView = lineChart

        if let _minimumY = minimumY {
            lineChart.minimumValue = CGFloat(minimumY!)
        }
        if let _maximumY = maximumY {
            lineChart.maximumValue = CGFloat(maximumY!)
        }
        
        lineChart.setState(.Collapsed, animated: false)
        
        if let _graphTitle = graphTitle {
            var headerView = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 50.0))
            headerView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            headerView.textAlignment = .Center
            headerView.textColor = UIColor.whiteColor()
            headerView.text = _graphTitle
            lineChart.headerView = headerView
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lineChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    // MARK: JBLineChartViewDataSource
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(lines.keys.array.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(lines.values.array[Int(lineIndex)].count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return CGFloat(lines.values.array[Int(lineIndex)][Int(horizontalIndex)])
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
        setToolTipVisible(true, animated: false, atTouchPoint: touchPoint)
        toolTipView.setText("X: \(horizontalIndex + 1) | Y: \(lines.values.array[Int(lineIndex)][Int(horizontalIndex)])")
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        setToolTipVisible(false, animated: true)
    }
    
    func addLine(lineValues : [Double]) -> String {
        lines["\(linesNextId + 1)"] = lineValues
        linesNextId++
        return "\(linesNextId)"
    }
    
    func removeLine(id : String) {
        lines.removeValueForKey(id)
    }
}
