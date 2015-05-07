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

class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GrapherPickerTableViewControllerDelegate {
    
    var singleReport : Report?
    var averageReport : AverageReport?
    var apiReport : ApiReport?
    var reportOneType = ReportType.Single // default
    var reportTwoType : ReportType?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let kShowGraphsViewController = "kShowGraphPickerViewController"
    private let kShowLineChartViewController = "kShowLineChartViewController"
    private let kShowBarChartViewController = "kShowBarChartViewController"
    private var graphSelected : DisplayInformation.ReportGraph?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        var graphIconButton = UIButton(frame: CGRectMake(0, 0, 36, 36))
        graphIconButton.setImage(UIImage(named: "graphIconDarkGrey.png"), forState: .Normal)
        graphIconButton.addTarget(self, action: "graphIconPressed", forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: graphIconButton)
        
        if reportTwoType == nil {
            segmentedControl.removeFromSuperview()
        }
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var reportType = segmentedControl.selectedSegmentIndex == 1 && reportTwoType != nil ? reportTwoType : reportOneType
        
        switch reportType! {
        case .Single:
            return DisplayInformation.ReportDescriptions.allValues.count
        case .Average:
            return DisplayInformation.AverageReportDescriptions.allValues.count
        case .Api:
            return DisplayInformation.ApiReportDescriptions.allValues.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReportCell", forIndexPath: indexPath) as! UITableViewCell

        var reportType = segmentedControl.selectedSegmentIndex == 1 && reportTwoType != nil ? reportTwoType : reportOneType

        // Configure the cell...
        switch reportType! {
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
        case .Api:
            cell.textLabel?.text = DisplayInformation.ApiReportDescriptions.allValues[indexPath.row].description
            if let text = getStringValueForDescription(DisplayInformation.ApiReportDescriptions.allValues[indexPath.row].description) {
                cell.detailTextLabel?.text = text
            } else {
                cell.detailTextLabel?.text = "N/A"
            }
        }
        
        cell.textLabel?.textColor = UIColor.lightGrayColor()
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        return cell
    }
    
    private func getStringValueForDescription(description : String) -> String? {
        var reportType = segmentedControl.selectedSegmentIndex == 1 && reportTwoType != nil ? reportTwoType : reportOneType

        switch reportType! {
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
            default:
                return nil

            }
        case .Api:
            switch description {
            case DisplayInformation.ApiReportDescriptions.AlgorithmName.description:
                return apiReport?.algorithmName
            case DisplayInformation.ApiReportDescriptions.FitFunctionName.description:
                return apiReport?.fitFunctionName
            case DisplayInformation.ApiReportDescriptions.AverageBestM.description:
                return (apiReport != nil) ? apiReport!.bestM.format(".4") : nil
            case DisplayInformation.ApiReportDescriptions.AverageComputationTime.description:
                return (apiReport != nil) ? apiReport!.computationTime.format(".4") : nil
            case DisplayInformation.ApiReportDescriptions.StandardDeviationBestM.description:
                return (apiReport != nil) ? apiReport!.stdDevBestM.format(".4") : nil
            case DisplayInformation.ApiReportDescriptions.StandardDeviationComputationTime.description:
                return (apiReport != nil) ? apiReport!.stdDevComputationTime.format(".4") : nil
            case DisplayInformation.ApiReportDescriptions.RoundTripTime.description:
                return (apiReport != nil) ? apiReport!.roundTripTime.format(".4") : nil
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
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 && reportTwoType == .Api {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            var graphIconButton = UIButton(frame: CGRectMake(0, 0, 36, 36))
            graphIconButton.setImage(UIImage(named: "graphIconDarkGrey.png"), forState: .Normal)
            graphIconButton.addTarget(self, action: "graphIconPressed", forControlEvents: .TouchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: graphIconButton)
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? GraphPickerNavigationController {
            if let segueIdentifier = segue.identifier {
                switch segueIdentifier {
                case kShowGraphsViewController:
                    navigationController.rootViewController?.delegate = self
                    navigationController.rootViewController?.reportType = reportOneType
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
                    switch reportOneType {
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
                    switch reportOneType {
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
