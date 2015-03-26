//
//  ParameterSelectionViewController.swift
//  Optimization Analysis
//
//  Created by Samuel Scott Robbins on 2/8/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit
import SRBubbleProgressTracker

class ParameterSelectionViewController: UIViewController, UITextFieldDelegate, AlgorithmManagerDelegate {
    
    // MARK: Initializations
    var algorithmManager : AlgorithmManager? = nil
    private var bubbleTrackerViewIsSetup = false
    private var currentTextFieldEdited = UITextField()
    private var currentSVContentOffset = CGPointMake(0, 0)
    private var keyBoardIsUp = false
    private var textFields = [UITextField]()
    let kShowSingleResultTableViewControllerSegue = "kShowSingleResultTableViewControllerSegue"
    let kShowAverageResultTableViewControllerSegue = "kShowAverageResultTableViewControllerSegue"
    
    @IBOutlet weak var bubbleTrackerVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bubbleTrackerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bubbleTrackerView: SRBubbleProgressTrackerView!

    // MARK: ViewControllerLifecycle and BubbleTrackerView setup
    override func viewDidLoad() {
        super.viewDidLoad()
        var tapGesture = UITapGestureRecognizer(target: self, action: "viewTapped")
        self.view.addGestureRecognizer(tapGesture)
        algorithmManager?.delegate = self
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
        if let algorithm = algorithmManager?.algorithm {
            for parameter in DisplayInformation.getParametersForAlgorithm(algorithm) {
                var label = UILabel(frame: CGRectMake(0, 0, (bubbleTrackerView.frame.size.width / 2.0) - ((40.0 / 2.0) + 20.0 + 8.0), 100)) // the 20 is me knowing how far from the bubble it's going to put the label (source). The 8 gives me space from the side, the 75 is the bubble diameter. 100 is an arbitrary height, probably should be calculated by the text you're putting in, sorry broski
                label.text = parameter.description
                label.textColor = UIColor.lightGrayColor()
                label.font = UIFont.systemFontOfSize(15)
                label.lineBreakMode = .ByWordWrapping
                label.textAlignment = .Right
                label.numberOfLines = 0
                leftViews.append(label)
            }
        } else { return nil }
        
        return leftViews
    }
    
    private func getRightViews() -> [UIView]? {
        var rightViews = [UIView]()
        
        if let algorithm = algorithmManager?.algorithm {
            for (index, _) in enumerate(DisplayInformation.getParametersForAlgorithm(algorithm)) {
                var textView = UITextField(frame: CGRectMake(0, 0, (bubbleTrackerView.frame.size.width / 2.0) - ((75.0 / 2.0) + 20.0 + 20.0), 25))
                textView.keyboardType = .NumberPad
                textView.borderStyle = .RoundedRect
                textView.backgroundColor = UIColor.lightGrayColor()
                textView.tag = index
                textView.delegate = self
                
                if index < DisplayInformation.getParametersForAlgorithm(algorithm).count - 1 {
                    var accessoryView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
                    accessoryView.backgroundColor = UIColor.darkGrayColor()
                    accessoryView.alpha = 0.8
                    var minusButton = UIButton(frame: CGRectMake((self.view.frame.size.width-150)/2.0, 5, 150, 30))
                    // configure the button here... you choose.
                    minusButton.setTitle("+/-", forState: .Normal)
                    minusButton.addTarget(self, action: "changeNumberString:", forControlEvents: .TouchUpInside)
                    accessoryView.addSubview(minusButton)
                    textView.inputAccessoryView = accessoryView
                }
                
                rightViews.append(textView)
            }
        } else { return nil }
        
        return rightViews
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
            if let parameters = getParametersFromTextFields(textFields) {
                algorithmManager?.runAlgorithmWithParameters(parameters)
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
        
        for textField in _textFields {
            if (textField.text.isEmpty || textField.text.toInt() == nil) {
                isValid = false
                break
            }
        }
        
        return isValid
    }
    
    private func getParametersFromTextFields(_textFields : [UITextField]) -> [Int]? {
        var parameters = [Int]()
    
        for textField in _textFields {
            if let parameter = textField.text.toInt() {
                parameters.append(parameter)
            } else { return nil }
        }
        
        return parameters
    }
    
    func singleReportFinished(report : Report?) {
        self.performSegueWithIdentifier(kShowSingleResultTableViewControllerSegue, sender: self)
    }
    
    func multipleReportFinished(report : AverageReport?) {
        self.performSegueWithIdentifier(kShowAverageResultTableViewControllerSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ResultTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowSingleResultTableViewControllerSegue:
                    viewController.singleReport = algorithmManager?.lastRunSingleReport
                    viewController.reportType = .Single
                case kShowAverageResultTableViewControllerSegue:
                    viewController.averageReport = algorithmManager?.lastRunMultipleReport
                    viewController.reportType = .Average
                default:
                    break
                }
            }
        }

    }
}
