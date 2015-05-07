# CS4900 Optimization App

###Description
An app written in swift to record and execute a handful of linear optimization algorithms with the ability to select certain variables. Afterward you can see your results, informational graphs, and compare your results to running on our server.

###Author
Scott Robbins - ssrobbi@bgsu.edu

###Prerequisites
* XCode 6
* Cocoapods

###Installation
* Clone or copy project to computer
* Run `pod install`
* Open `OptimizationAnalysis.xcworkspace` and **NOT** `OptimizationAnalysis.xcodeproj`

###Usage
* Choose to run the algorithm on the `App`, the `Api` (server) or `Both`
* Pick the type of algorithm you would like to run, the fit function to use and fill in the parameters how you'd like
* Click `Run` and when your algorithms are done executing, you will be moved to the **Results** screen, where you can view your results and select graphs to view

###Algorithms Available
* Hill Climbing
* Steepest Ascent Hill Climbing
* Steepest Ascent Hill Climbing With Replacement
* Steepest Ascent Hill Climbing With Random Restart
* Simulated Annealing
* Tabu Search
* Partical Swarm

###Example
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.31.51%20AM.png" alt="Choose How To Run" width="200" float="left"/>
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.32.05%20AM.png" alt="Choose Algorithm" width="200" float="left"/>
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.32.15%20AM.png" alt="Choose Algorithm" width="200" float="left"/>
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.32.56%20AM.png" alt="Choose Algorithm" width="200" float="left"/>
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.33.02%20AM.png" alt="Choose Algorithm" width="200" float="left"/>
<img src="https://github.com/ScottRobbins/OptimizationApp/blob/master/OptimizationAnalysis/iOS%20Simulator%20Screen%20Shot%20May%207%2C%202015%2C%201.33.16%20AM.png" alt="Choose Algorithm" width="200" float="left"/>

###Architecture

The 2 driver classes are `AppAlgorithmManager.swift` and `ApiAlgorithmManager.swift`. They will manage your algorithms and parameters, along with managing running the algorithms.

Inside of the `Algorithms` group folder, is a series of files that contain the optimization algorithms.

You will receive one of three different reports depending on if you ran a report 1 time on the app (Single Report), more than 1 time on the app (Average Report) or on the API (Api report)

**Single Report**
* `algorithmName` - Name of the Algorithm
* `fitFunctionName` - Name of the fit function
* `bestSolution` - Best solution array
* `bestM` - the best M found
* `computationTime` - How long in miliseconds it took to complete the algorithm
* `iterations` - an array that will give you the best M at each iteration through the algorithm

**Average Report**
* `reports` - An array of every report generated
* `algorithmName` - Name of the Algorithm
* `fitFunctionName` - Name of the fit function
* `averageBestM` - the average best M 
* `averageComputationTime` - How long in miliseconds, on average, it took to complete the algorithm
* `stdDevBestM` - standard deviation of the best Ms
* `stdDevComputationTime` - standard deviation of the computation times

**Api Report**
* `algorithmName` - Name of the Algorithm
* `fitFunctionName` - Name of the fit function
* `bestM` - the best M (or average best M if run multiple times)
* `computationTime` - How long in miliseconds (possibly on average) it took to complete the algorithm
* `stdDevBestM` - standard deviation of the best Ms (0 if only run once)
* `stdDevComputationTime` - standard deviation of the computation times (0 if only run once)
* `roundTripTime` - How long in miliseconds it took to call the Api and get a response
