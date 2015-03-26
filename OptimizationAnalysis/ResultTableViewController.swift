//
//  ResultTableViewController.swift
//  OptimizationAnalysis
//
//  Created by Samuel Scott Robbins on 3/25/15.
//  Copyright (c) 2015 Scott Robbins Software. All rights reserved.
//

import UIKit

enum GraphType {
    case Bar
    case Line
}

class ResultTableViewController: UITableViewController, GrapherPickerTableViewControllerDelegate {
    
    var singleReport : Report? = nil
    var averageReport : AverageReport? = nil
    var reportType = ReportType.Single // default
    
    private let kShowGraphsViewController = "kShowGraphPickerViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Report"
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        var graphIconButton = UIButton(frame: CGRectMake(0, 0, 36, 36))
        graphIconButton.setImage(UIImage(named: "graphIconDarkGrey.png"), forState: .Normal)
        graphIconButton.addTarget(self, action: "graphIconPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: graphIconButton)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch reportType {
        case .Single:
            return DisplayInformation.ReportDescriptions.allValues.count
        case .Average:
            return DisplayInformation.AverageReportDescriptions.allValues.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        switch reportType {
        case .Single:
            cell.textLabel?.text = DisplayInformation.ReportDescriptions.allValues[indexPath.row].rawValue
            if let text = getStringValueForDescription(DisplayInformation.ReportDescriptions.allValues[indexPath.row].rawValue) {
                cell.detailTextLabel?.text = text
            } else {
                cell.detailTextLabel?.text = "N/A"
            }
        case .Average:
            cell.textLabel?.text = DisplayInformation.AverageReportDescriptions.allValues[indexPath.row].rawValue
            if let text = getStringValueForDescription(DisplayInformation.AverageReportDescriptions.allValues[indexPath.row].rawValue) {
                cell.detailTextLabel?.text = text
            } else {
                cell.detailTextLabel?.text = "N/A"
            }
        }
        
        cell.backgroundColor = UIColor.darkGrayColor()
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        return cell
    }
    
    private func getStringValueForDescription(description : String) -> String? {
        switch reportType {
        case .Single:
            switch description {
            case DisplayInformation.ReportDescriptions.AlgorithmName.rawValue:
                return singleReport?.algorithmName
            case DisplayInformation.ReportDescriptions.FitFunctionName.rawValue:
                return singleReport?.fitFunctionName
            case DisplayInformation.ReportDescriptions.BestM.rawValue:
                return (singleReport? != nil) ? "\(singleReport!.bestM)" : nil
            case DisplayInformation.ReportDescriptions.ComputationTime.rawValue:
                return (singleReport? != nil) ? "\(singleReport!.computationTime)" : nil
            case DisplayInformation.ReportDescriptions.Dimension.rawValue:
                return (singleReport? != nil) ? "\(singleReport!.dimension)" : nil
            default:
                return nil
            }
        case .Average:
            switch description {
            case DisplayInformation.AverageReportDescriptions.AlgorithmName.rawValue:
                return averageReport?.algorithmName
            case DisplayInformation.AverageReportDescriptions.FitFunctionName.rawValue:
                return averageReport?.fitFunctionName
            case DisplayInformation.AverageReportDescriptions.AverageBestM.rawValue:
                return (averageReport? != nil) ? "\(averageReport!.averageBestM)" : nil
            case DisplayInformation.AverageReportDescriptions.AverageComputationTime.rawValue:
                return (averageReport? != nil) ? "\(averageReport!.averageComputationTime)" : nil
            case DisplayInformation.AverageReportDescriptions.StandardDeviationBestM.rawValue:
                return (averageReport? != nil) ? "\(averageReport!.stdDevBestM)" : nil
            case DisplayInformation.AverageReportDescriptions.StandardDeviationComputationTime.rawValue:
                return (averageReport? != nil) ? "\(averageReport!.stdDevComputationTime)" : nil
            case DisplayInformation.AverageReportDescriptions.Dimension.rawValue:
                return (averageReport? != nil) ? "\(averageReport!.dimension)" : nil
            default:
                return nil

            }
        }
    }
    
    func graphIconPressed() {
        self.performSegueWithIdentifier(kShowGraphsViewController, sender: self)
    }
    
    func graphWasSelected(reportGraph : DisplayInformation.ReportGraph) {
        println("\(reportGraph.description)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? GraphPickerTableViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowGraphsViewController:
                    viewController.delegate = self
                    viewController.reportType = reportType
                default:
                    break
                }
            }
        }
    }
}
