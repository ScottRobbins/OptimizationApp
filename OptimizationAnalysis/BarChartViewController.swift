//
//  BarChartViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 2/20/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import JBChartView

class BarChartViewController: BaseChartViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    // MARK: Public Declarations
    var minimumY : Double?
    var maximumY : Double?
    var reportType = ReportType.Single // default
    var graphTitle : String?
    
    @IBOutlet weak var barChart: JBBarChartView!
    
    private var bars = [Bar]()
    
    // MARK: VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        barChart.delegate = self
        barChart.dataSource = self
        chartView = barChart
        
        if let _minimumY = minimumY {
            barChart.minimumValue = CGFloat(minimumY!)
        }
        if let _maximumY = maximumY {
            barChart.maximumValue = CGFloat(maximumY!)
        }
        
        barChart.setState(.Collapsed, animated: false)
        
        if let _graphTitle = graphTitle {
            var headerView = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 50.0))
            headerView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            headerView.textAlignment = .Center
            headerView.textColor = UIColor.whiteColor()
            headerView.text = _graphTitle
            barChart.headerView = headerView
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    // MARK: JBBarChartViewDatasource
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(bars.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(bars[Int(index)].value)
    }
    
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return UIColor.lightGrayColor()
    }
    
    // MARK: JBBarChartViewDelegate
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt, touchPoint: CGPoint) {
        setToolTipVisible(true, animated: false, atTouchPoint: touchPoint)
        toolTipView.setText("\(bars[Int(index)].name): \(bars[Int(index)].value)")
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        setToolTipVisible(false, animated: true)
    }
    
    func addBar(bar : Bar) -> String {
        bars.append(bar)
        return bar.name
    }
    
    func removeBar(barName : String) {
        for (i, bar) in enumerate(bars) {
            if bar.name == barName {
                bars.removeAtIndex(i)
                break
            }
        }
    }
    
}
