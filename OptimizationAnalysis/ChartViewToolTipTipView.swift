//
//  ChartViewToolTipTipView.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/19/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

let kChartViewToolTipViewDefaultWidth : CGFloat = UIScreen.mainScreen().bounds.size.width - 20.0;
let kChartViewToolTipViewDefaultHeight : CGFloat = 50.0;

class ChartViewToolTipTipView: UIView {

    convenience init() {
        self.init(frame: CGRectMake(0, 0, kChartViewToolTipViewDefaultWidth, kChartViewToolTipViewDefaultHeight))
        self.backgroundColor = UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var context = UIGraphicsGetCurrentContext()
        UIColor.clearColor().set()
        CGContextFillRect(context, rect)
        CGContextSaveGState(context)
        
        UIColor.clearColor().set()
        CGContextFillRect(context, rect)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect))
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        CGContextClosePath(context)
        CGContextSetFillColorWithColor(context, UIColor(white: 1.0, alpha: 0.9).CGColor)
        CGContextFillPath(context)
        CGContextRestoreGState(context)
    }

}
