//
//  BaseChartViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/19/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import JBChartView

let kChartViewControllerAnimationDuration = 0.25

class BaseChartViewController: UIViewController {
    
    // MARK: Declarations
    var toolTipView = ChartViewToolTipView()
    var toolTipVisible = false
    var chartView = JBChartView()
    
    internal let colorForGraph = [UIColor.orangeColor(), UIColor.lightGrayColor(), UIColor.whiteColor(), UIColor.blueColor()]
    private var toolTipTipView = ChartViewToolTipTipView()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setToolTipVisible(toolTipVisible : Bool, animated : Bool, atTouchPoint touchPoint : CGPoint) {
        self.toolTipVisible = toolTipVisible
        var _chartView = chartView
        
        toolTipView.alpha = 0.0
        self.view.addSubview(toolTipView)
        
        if toolTipVisible {
            adjustToolTipPosition(touchPoint)
        }
        
        if animated {
            UIView.animateWithDuration(kChartViewControllerAnimationDuration, animations: { () -> Void in
                self.adjustToolTipVisibility()
            }, completion: { (finished) -> Void in
                if (!toolTipVisible) {
                    self.adjustToolTipPosition(touchPoint)
                }
            })
        } else {
            adjustToolTipVisibility()
        }
    }
    
    private func adjustToolTipPosition(touchPoint : CGPoint) {
        var originalTouchPoint = self.view.convertPoint(touchPoint, fromView: chartView)
        var convertedTouchPoint = originalTouchPoint // modified
        var _chartView = chartView
        
        var minChartX = chartView.frame.origin.x + ceil(toolTipView.frame.size.width * 0.5);
        if convertedTouchPoint.x < minChartX {
            convertedTouchPoint.x = minChartX;
        }
        
        var maxChartX = chartView.frame.origin.x + chartView.frame.size.width - ceil(toolTipView.frame.size.width * 0.5);
        if convertedTouchPoint.x > maxChartX {
            convertedTouchPoint.x = maxChartX;
        }
        
        toolTipView.frame = CGRectMake(convertedTouchPoint.x - ceil(toolTipView.frame.size.width * 0.5), 64, toolTipView.frame.size.width, toolTipView.frame.size.height);
        
        var minTipX = chartView.frame.origin.x + toolTipTipView.frame.size.width;
        if originalTouchPoint.x < minTipX {
            originalTouchPoint.x = minTipX;
        }
        
        var maxTipX = chartView.frame.origin.x + chartView.frame.size.width - toolTipTipView.frame.size.width;
        if originalTouchPoint.x > maxTipX {
            originalTouchPoint.x = maxTipX;
        }
        
        toolTipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(toolTipTipView.frame.size.width * 0.5), CGRectGetMaxY(toolTipTipView.frame), toolTipTipView.frame.size.width, toolTipTipView.frame.size.height);
    }
    
    private func adjustToolTipVisibility() {
        toolTipView.alpha = toolTipVisible ? 0.9 : 0.0;
        toolTipTipView.alpha = toolTipVisible ? 1.0 : 0.0;
    }
    
    func setToolTipVisible(toolTipVisible : Bool, animated : Bool) {
        setToolTipVisible(toolTipVisible, animated: animated, atTouchPoint: CGPointZero)
    }
    
    func setToolTipVisible(toolTipVisible : Bool) {
        setToolTipVisible(toolTipVisible, animated: false)
    }
    
    func hideChart() {
        chartView.setState(.Collapsed, animated: true)
    }
    
    func showChart() {
        chartView.setState(.Expanded, animated: true)
    }
    
    
}
