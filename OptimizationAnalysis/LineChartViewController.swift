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
    var YAxisLabelText : DisplayInformation.AxisLabel?
    var XAxisLabelText : DisplayInformation.AxisLabel?
    
    // MARK: Private Declarations
    private var lines = Dictionary<String, [Double]>()
    private var linesNextId = 0
    private var viewHasBeenLayedOut = false
    
    @IBOutlet weak var lineChart: JBLineChartView!
    @IBOutlet weak var yAxisLabel: UILabel!
    @IBOutlet weak var xAxisLabel: UILabel!
    @IBOutlet weak var spacerView: UIView!
    
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
        
        if let _xAxisLabelText = XAxisLabelText {
            var footerView = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 21.0))
            footerView.textAlignment = .Center
            footerView.textColor = UIColor.lightGrayColor()
            footerView.text = _xAxisLabelText.rawValue
            lineChart.footerView = footerView
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewHasBeenLayedOut == false {
            viewHasBeenLayedOut = true
            
            if let _yAxisLabelText = YAxisLabelText {
                var yAxisLabel = UILabel(frame: CGRectMake(lineChart.frame.origin.x - 8.0 - 21.0, lineChart.frame.origin.y, lineChart.frame.size.height, 21.0))
                yAxisLabel.textAlignment = .Center
                yAxisLabel.text = _yAxisLabelText.rawValue
                yAxisLabel.textColor = UIColor.lightGrayColor()
                yAxisLabel.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
                yAxisLabel.frame.origin = CGPointMake(lineChart.frame.origin.x - 8.0 - 21.0, lineChart.frame.origin.y)
                self.view.addSubview(yAxisLabel)
            } else {
                spacerView.removeFromSuperview()
            }
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
        return Int(lineIndex) < colorForGraph.count ? colorForGraph[Int(lineIndex)] : colorForGraph[Int(lineIndex) % colorForGraph.count]
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
        if let headerView = lineChart.headerView as? UILabel {
            if let _xAxisLabelText = XAxisLabelText {
                if let _yAxisLabelText = YAxisLabelText {
                    let lineValue = lines.values.array[Int(lineIndex)][Int(horizontalIndex)].format(".4")
                    headerView.text = "\(_xAxisLabelText.rawValue) \(horizontalIndex + 1): \(lineValue)"
                }
            }
        }
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        if let headerView = lineChart.headerView as? UILabel {
            headerView.text = graphTitle
        }
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
