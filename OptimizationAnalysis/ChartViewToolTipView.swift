//
//  ChartViewToolTipView.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/19/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit


class ChartViewToolTipView: UIView {
    // MARK: Declarations
    var textLabel = UILabel()
    
    // MARK: Initializers
    convenience init() {
        self.init(frame: CGRectMake(0, 0, kChartViewToolTipViewDefaultWidth, kChartViewToolTipViewDefaultHeight))
        setupTextLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextLabel()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextLabel()
    }
  
    func setupTextLabel() {
        textLabel.textAlignment = .Center
        textLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.addSubview(textLabel)
    }
    
    // MARK: Functions
    func setText(text : String) {
        textLabel.text = text
        self.setNeedsLayout()
    }
    
    func setToolTipColor(color : UIColor) {
        self.backgroundColor = color
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = self.bounds
    }

}
