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
    private let kShowLineChartViewController = "kShowLineChartViewController"
    private let kShowBarChartViewController = "kShowBarChartViewController"
    private var graphSelected : DisplayInformation.ReportGraph?
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        switch reportType {
        case .Single:
            cell.textLabel?.text = DisplayInformation.ReportDescriptions.allValues[indexPath.row].description
            if let text = getStringValueForDescription(DisplayInformation.ReportDescriptions.allValues[indexPath.row].description) {
                cell.detailTextLabel?.text = text
            } else {
                cell.detailTextLabel?.text = "N/A"
            }
        case .Average:
            cell.textLabel?.text = DisplayInformation.AverageReportDescriptions.allValues[indexPath.row].description
            if let text = getStringValueForDescription(DisplayInformation.AverageReportDescriptions.allValues[indexPath.row].description) {
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
            case DisplayInformation.ReportDescriptions.AlgorithmName.description:
                return singleReport?.algorithmName
            case DisplayInformation.ReportDescriptions.FitFunctionName.description:
                return singleReport?.fitFunctionName
            case DisplayInformation.ReportDescriptions.BestM.description:
                return (singleReport != nil) ? singleReport!.bestM.format(".4") : nil
            case DisplayInformation.ReportDescriptions.ComputationTime.description:
                return (singleReport != nil) ? singleReport!.computationTime.format(".4") : nil
            case DisplayInformation.ReportDescriptions.Dimension.description:
                return (singleReport != nil) ? "\(singleReport!.dimension)" : nil
            default:
                return nil
            }
        case .Average:
            switch description {
            case DisplayInformation.AverageReportDescriptions.AlgorithmName.description:
                return averageReport?.algorithmName
            case DisplayInformation.AverageReportDescriptions.FitFunctionName.description:
                return averageReport?.fitFunctionName
            case DisplayInformation.AverageReportDescriptions.AverageBestM.description:
                return (averageReport != nil) ? averageReport!.averageBestM.format(".4") : nil
            case DisplayInformation.AverageReportDescriptions.AverageComputationTime.description:
                return (averageReport != nil) ? averageReport!.averageComputationTime.format(".4") : nil
            case DisplayInformation.AverageReportDescriptions.StandardDeviationBestM.description:
                return (averageReport != nil) ? averageReport!.stdDevBestM.format(".4") : nil
            case DisplayInformation.AverageReportDescriptions.StandardDeviationComputationTime.description:
                return (averageReport != nil) ? averageReport!.stdDevComputationTime.format(".4") : nil
            case DisplayInformation.AverageReportDescriptions.Dimension.description:
                return (averageReport != nil) ? "\(averageReport!.dimension)" : nil
            default:
                return nil

            }
        }
    }
    
    func graphIconPressed() {
        self.performSegueWithIdentifier(kShowGraphsViewController, sender: self)
    }
    
    func graphWasSelected(reportGraph : DisplayInformation.ReportGraph) {
        graphSelected = reportGraph
        
        switch reportGraph {
        case .IterationVsBestM:
            self.performSegueWithIdentifier(kShowLineChartViewController, sender: self)
        case .ReportVsBestM:
            self.performSegueWithIdentifier(kShowBarChartViewController, sender: self)
        case .ReportVsComputationTime:
            self.performSegueWithIdentifier(kShowBarChartViewController, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? GraphPickerNavigationController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowGraphsViewController:
                    navigationController.rootViewController?.delegate = self
                    navigationController.rootViewController?.reportType = reportType
                default:
                    break
                }
            }
        } else if let viewController = segue.destinationViewController as? LineChartViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowLineChartViewController:
                    viewController.title = "Report"
                    viewController.graphTitle = graphSelected?.rawValue
                    switch reportType {
                    case .Single:
                        if let _graphSelected = graphSelected {
                            switch _graphSelected {
                            case .IterationVsBestM:
                                if singleReport != nil {
                                    viewController.minimumY = singleReport!.minimumBestM
                                    viewController.maximumY = singleReport!.maximumBestM
                                    viewController.YAxisLabelText = .BestM
                                    viewController.XAxisLabelText = .Iteration
                                    viewController.addLine(singleReport!.allBestMs)
                                }
                            default:
                                break
                            }
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            }
        } else if let viewController = segue.destinationViewController as? BarChartViewController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowBarChartViewController:
                    viewController.title = "Report"
                    viewController.graphTitle = graphSelected?.rawValue
                    switch reportType {
                    case .Average:
                        if let _graphSelected = graphSelected {
                            switch _graphSelected {
                            case .ReportVsBestM:
                                if averageReport != nil {
                                    for (i, report) in enumerate(averageReport!.reports) {
                                        var bar = Bar(name: "\(report.algorithmName) \(i)", value: report.bestM)
                                        viewController.addBar(bar)
                                    }
                                    
                                    viewController.minimumY = averageReport!.minimumReportsBestM * 0.99
                                    viewController.maximumY = averageReport!.maximumReportsBestM
                                    viewController.XAxisLabelText = .Report
                                    viewController.YAxisLabelText = .BestM
                                }
                            case .ReportVsComputationTime:
                                if averageReport != nil {
                                    for (i, report) in enumerate(averageReport!.reports) {
                                        var bar = Bar(name: "\(report.algorithmName) \(i)", value: report.computationTime)
                                        viewController.addBar(bar)
                                    }
                                    
                                    viewController.minimumY = averageReport!.minimumReportsComputationTime * 0.99
                                    viewController.maximumY = averageReport!.maximumReportsComputationTime
                                    viewController.XAxisLabelText = .Report
                                    viewController.YAxisLabelText = .ComputationTime
                                }
                            default:
                                break
                            }
                        }
                    default:
                        break
                    }
                default:
                    break
                }
            }

        }
    }
}
