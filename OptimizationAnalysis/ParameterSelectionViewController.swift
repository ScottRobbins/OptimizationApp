//
//  ParameterSelectionViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import SRBubbleProgressTracker

class ParameterSelectionViewController: UIViewController, UITextFieldDelegate, AppAlgorithmManagerDelegate, ApiAlgorithmManagerDelegate {
    
    // MARK: Publid Declarations
    var appAlgorithmManager : AppAlgorithmManager?
    var apiAlgorithmManager : ApiAlgorithmManager?
    
    let kShowResultTableViewController = "kShowResultTableViewController"
    
    @IBOutlet weak var bubbleTrackerVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrackerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bubbleTrackerView: SRBubbleProgressTrackerView!
    
    // MARK: Private Declarations
    private var bubbleTrackerViewIsSetup = false
    private var currentTextFieldEdited = UITextField()
    private var currentSVContentOffset = CGPointMake(0, 0)
    private var keyBoardIsUp = false
    private var textFields = [UITextField]()
    private var reportsFinished = 0
    private var reportTypes : (ReportType, ReportType?) = (ReportType.Single, nil)


    // MARK: ViewControllerLifecycle and BubbleTrackerView setup
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGesture = UITapGestureRecognizer(target: self, action: "viewTapped")
        self.view.addGestureRecognizer(tapGesture)
        appAlgorithmManager?.delegate = self
        apiAlgorithmManager?.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !bubbleTrackerViewIsSetup { // Needed so when called again for animation it doesn't redraw
            bubbleTrackerHeightConstraint.constant = UIScreen.mainScreen().bounds.size.height - 64.0 - bubbleTrackerVerticalSpaceConstraint.constant * 2 // navigation bar
            bubbleTrackerView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, bubbleTrackerHeightConstraint.constant)
            
            var leftLabels = [UIView]()
            var rightTextViews = [UIView]()
            
            if let temp = getLeftViews() {
                leftLabels = temp
            } else { return }
            
            if let temp = getRightViews() {
                rightTextViews = temp
                if let temp = rightTextViews as? [UITextField] {
                    textFields = temp
                }
                
            } else { return }
            
            // Will place bubbles in the center of the view
            bubbleTrackerView.setupInitialBubbleProgressTrackerView(leftLabels.count, dotDiameter: 40.0, allign: .Vertical, leftOrTopViews: leftLabels, rightOrBottomViews: rightTextViews)
            bubbleTrackerViewIsSetup = true

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func getLeftViews() -> [UIView]? {
        var leftViews = [UIView]()
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            for parameter in apiAlgorithmManager!.algorithm.parameters {
                var label = getLeftViewLabelWithText(parameter.name)
                leftViews.append(label)
            }
        } else {
            if let algorithm = appAlgorithmManager?.algorithm {
                for parameter in DisplayInformation.getParametersForAlgorithm(algorithm.algorithmType) {
                    var label = getLeftViewLabelWithText(parameter.name)
                    leftViews.append(label)
                }
            } else { return nil }
        }
        
        return leftViews
    }
    
    private func getLeftViewLabelWithText(text : String) -> UILabel {
        var label = UILabel(frame: CGRectMake(0, 0, (bubbleTrackerView.frame.size.width / 2.0) - ((40.0 / 2.0) + 20.0 + 8.0), 100)) // the 20 is me knowing how far from the bubble it's going to put the label (source). The 8 gives me space from the side, the 75 is the bubble diameter. 100 is an arbitrary height, probably should be calculated by the text you're putting in, sorry broski
        label.text = text
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(15)
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Right
        label.numberOfLines = 0

        return label
    }
    
    private func getRightViews() -> [UIView]? {
        var rightViews = [UIView]()
        
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            for (index, _) in enumerate(apiAlgorithmManager!.algorithm.parameters) {
                var textView = getRightViewTextViewWithIndex(index)
                rightViews.append(textView)
            }
        } else {
            if let algorithm = appAlgorithmManager?.algorithm {
                for (index, _) in enumerate(DisplayInformation.getParametersForAlgorithm(algorithm.algorithmType)) {
                    var textView = getRightViewTextViewWithIndex(index)
                    rightViews.append(textView)
                }
            } else { return nil }
        }
        
        return rightViews
    }
    
    private func getRightViewTextViewWithIndex(index : Int) -> UITextField {
        var textView = UITextField(frame: CGRectMake(0, 0, (bubbleTrackerView.frame.size.width / 2.0) - ((75.0 / 2.0) + 20.0 + 20.0), 25))
        
        if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
            switch apiAlgorithmManager!.algorithm.parameters[index].dataType {
            case .Integer:
                textView.keyboardType = .NumberPad
            case .Float:
                textView.keyboardType = .DecimalPad
            default:
                textView.keyboardType = .NumberPad
            }
        } else {
            switch appAlgorithmManager!.algorithm.parameters[index].dataType {
            case .Integer:
                textView.keyboardType = .NumberPad
            case .Float:
                textView.keyboardType = .DecimalPad
            default:
                textView.keyboardType = .NumberPad
            }
        }

        textView.borderStyle = .RoundedRect
        textView.backgroundColor = UIColor.lightGrayColor()
        textView.tag = index
        textView.delegate = self
        
        var accessoryView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        accessoryView.backgroundColor = UIColor.darkGrayColor()
        accessoryView.alpha = 0.8
        var minusButton = UIButton(frame: CGRectMake((self.view.frame.size.width-150)/2.0, 5, 150, 30))
        // configure the button here... you choose.
        minusButton.setTitle("+/-", forState: .Normal)
        minusButton.addTarget(self, action: "changeNumberString:", forControlEvents: .TouchUpInside)
        accessoryView.addSubview(minusButton)
        textView.inputAccessoryView = accessoryView
        
        return textView
    }
    
    // MARK: Text Field manage
    func changeNumberString(sender : UIButton!) {
        if (currentTextFieldEdited.text.hasPrefix("-")) {
            let index = advance(currentTextFieldEdited.text.startIndex, 1)
            currentTextFieldEdited.text = currentTextFieldEdited.text.substringFromIndex(index)
        } else {
            currentTextFieldEdited.text = "-\(currentTextFieldEdited.text)"
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextFieldEdited = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        bubbleTrackerView.bubbleCompleted(textField.tag + 1)
    }
    
    func viewTapped() {
        self.view.endEditing(true)
        keyBoardIsUp = false
    }
    
    func keyboardWasShown(aNotification : NSNotification) {
        if !keyBoardIsUp {
            currentSVContentOffset = scrollView.contentOffset
            keyBoardIsUp = true
        }
        
        if let userInfo = aNotification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                let kbSize = CGSizeMake(keyboardFrame.size.width, keyboardFrame.size.height + 40.0) // 40.0 for accessory view
                let activeRect = self.view.convertRect(currentTextFieldEdited.frame, fromView: currentTextFieldEdited.superview)
                var aRect = self.view.bounds
                aRect.size.height -= kbSize.height
                
                var origin = activeRect.origin
                origin.y -= scrollView.contentOffset.y
                origin.y = abs(origin.y)
                if !CGRectContainsPoint(aRect, origin) {
                    let scrollPoint = CGPointMake(0.0, CGRectGetMaxY(activeRect) - (aRect.size.height))
                    scrollView.setContentOffset(scrollPoint, animated: true)
                }
            }
        }
    }
    
    func keyboardWillBeHidden(aNotification : NSNotification) {
        scrollView.setContentOffset(currentSVContentOffset, animated: true)
    }
    
    @IBAction func runTest(sender: UIBarButtonItem) {
        if textFieldsAreValid(textFields) {
            // Lets run some shit
            reportsFinished = 0
            reportTypes = (ReportType.Single, nil)
            
            fillParametersWithTextFieldValues(textFields)
            if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
                if apiAlgorithmManager?.shouldBeRun == true {
                    apiAlgorithmManager?.runAlgorithm()
                }
            } else {
                if apiAlgorithmManager?.shouldBeRun == true {
                    apiAlgorithmManager?.runAlgorithm()
                }
                
                if appAlgorithmManager?.shouldBeRun == true {
                    appAlgorithmManager?.runAlgorithm()
                }
            }
        } else {
            var alertAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            var alertcontroller = UIAlertController(title: "Invalid Entry", message: "One or more of your inputs is invalid", preferredStyle: .Alert)
            alertcontroller.addAction(alertAction)
            self.presentViewController(alertcontroller, animated: true, completion: nil)
        }
    }
    
    private func textFieldsAreValid(_textFields : [UITextField]) -> Bool {
        var isValid = true
        
        for (i, textField) in enumerate(_textFields) {
            if (textField.text.isEmpty || textField.text.doubleValue == nil) {
                isValid = false
                break
            }
            
            var min = apiAlgorithmManager!.algorithm.parameters[i].min
            var max = apiAlgorithmManager!.algorithm.parameters[i].max
            
            if !(textField.text.doubleValue <= max && textField.text.doubleValue >= min) {
                isValid = false
                break
            }
            
        }
        
        return isValid
    }
    
    private func fillParametersWithTextFieldValues(_textFields : [UITextField]) {
        for (i, textField) in enumerate(_textFields) {
            if apiAlgorithmManager?.shouldBeRun == true && !(appAlgorithmManager?.shouldBeRun == true) {
                
                apiAlgorithmManager!.algorithm.parameters[i].value = apiAlgorithmManager!.algorithm.parameters[i].dataType == ParameterDataType.Integer ? textField.text.intValue : textField.text.doubleValue
            } else {
                if let algorithm = appAlgorithmManager?.algorithm {
                    appAlgorithmManager?.algorithm.parameters[i].value = appAlgorithmManager!.algorithm.parameters[i].dataType == ParameterDataType.Integer ? textField.text.intValue : textField.text.doubleValue
                }
            }
        }
    }
    
    private func getParametersFromTextFields(_textFields : [UITextField]) -> [Double]? {
        var parameters = [Double]()
    
        for textField in _textFields {
            if let parameter = textField.text.doubleValue {
                parameters.append(parameter)
            } else { return nil }
        }
        
        return parameters
    }
    
    func singleReportFinished(_ : Report?) {
        reportsFinished += 1
        
        if (apiAlgorithmManager?.shouldBeRun == true && reportsFinished == 2) {
            reportTypes = (reportTypes.0, ReportType.Single)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else if apiAlgorithmManager?.shouldBeRun == false {
            reportTypes = (ReportType.Single, reportTypes.1)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else {
            reportTypes = (ReportType.Single, nil)
            reportTypes.1 = .Single
        }
    }
    
    func multipleReportFinished(_ : AverageReport?) {
        reportsFinished += 1
        
        if (apiAlgorithmManager?.shouldBeRun == true && reportsFinished == 2) {
            reportTypes = (reportTypes.0, ReportType.Average)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else if apiAlgorithmManager?.shouldBeRun == false {
            reportTypes = (ReportType.Average, reportTypes.1)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else {
            reportTypes = (ReportType.Average, nil)
        }
    }
    
    func apiReportFinished(_: ApiReport?) {
        reportsFinished += 1
        
        if (appAlgorithmManager?.shouldBeRun == true && reportsFinished == 2) {
            reportTypes = (reportTypes.0, ReportType.Api)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else if appAlgorithmManager?.shouldBeRun == false {
            reportTypes = (ReportType.Api, reportTypes.1)
            self.performSegueWithIdentifier(kShowResultTableViewController, sender: self)
        } else {
            reportTypes = (reportTypes.0, ReportType.Api)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ResultTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowResultTableViewController:
                    viewController.reportOneType = reportTypes.0
                    switch reportTypes.0 {
                    case .Single:
                        viewController.singleReport = appAlgorithmManager?.lastRunSingleReport
                    case .Average:
                        viewController.averageReport = appAlgorithmManager?.lastRunMultipleReport
                    case .Api:
                        viewController.apiReport = apiAlgorithmManager?.lastRunApiReport
                    }
                    
                    if let reportType = reportTypes.1 {
                        viewController.reportTwoType = reportType
                        
                        switch reportType {
                        case .Single:
                            viewController.singleReport = appAlgorithmManager?.lastRunSingleReport
                        case .Average:
                            viewController.averageReport = appAlgorithmManager?.lastRunMultipleReport
                        case .Api:
                            viewController.apiReport = apiAlgorithmManager?.lastRunApiReport
                        }
                    }
                
                default:
                    break
                }
            }
        }

    }
}
