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
    var YAxisLabelText : DisplayInformation.AxisLabel?
    var XAxisLabelText : DisplayInformation.AxisLabel?
    
    @IBOutlet weak var barChart: JBBarChartView!
    @IBOutlet weak var spacerView: UIView!
    
    private var bars = [Bar]()
    private var viewHasBeenLayedOut = false
    
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
        
        if let _xAxisLabelText = XAxisLabelText {
            var footerView = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 21.0))
            footerView.textAlignment = .Center
            footerView.textColor = UIColor.lightGrayColor()
            footerView.text = _xAxisLabelText.rawValue
            barChart.footerView = footerView
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
    }
    
    override func viewDidLayoutSubviews() {
        if viewHasBeenLayedOut == false {
            viewHasBeenLayedOut = true
            
            if let _yAxisLabelText = YAxisLabelText {
                var yAxisLabel = UILabel(frame: CGRectMake(barChart.frame.origin.x - 8.0 - 21.0, barChart.frame.origin.y, barChart.frame.size.height, 21.0))
                yAxisLabel.textAlignment = .Center
                yAxisLabel.text = _yAxisLabelText.rawValue
                yAxisLabel.textColor = UIColor.lightGrayColor()
                yAxisLabel.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
                yAxisLabel.frame.origin = CGPointMake(barChart.frame.origin.x - 8.0 - 21.0, barChart.frame.origin.y)
                self.view.addSubview(yAxisLabel)
            } else {
                spacerView.removeFromSuperview()
            }
        }
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
        return colorForGraph[0]
    }
    
    // MARK: JBBarChartViewDelegate
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt, touchPoint: CGPoint) {
        if let headerLabel = barChart.headerView as? UILabel {
            let barValue = bars[Int(index)].value.format(".4")
            headerLabel.text = "\(bars[Int(index)].name): \(barValue)"
        }
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        if let headerLabel = barChart.headerView as? UILabel {
            headerLabel.text = graphTitle
        }
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
