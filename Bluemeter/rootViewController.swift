//
//  ViewController.swift
//  Bluemeter
//
//  Created by Brandon Main on 12/19/19.
//  Copyright © 2019 Brandon Main. All rights reserved.
//

import UIKit
import Charts
import MetalKit

class rootViewController: UIViewController, ChartViewDelegate, MTKViewDelegate {
    
    // MARK: - Protocol Delegate Methods
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    /**
        Delegate Method that draws the contained view using GPU acceleration.
     */
    func draw(in view: MTKView) {
        let renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor == nil)
        {
            return;
        }
    
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        commandEncoder?.endEncoding()
        
        let drawable = view.currentDrawable
        commandBuffer.present(drawable!)
        commandBuffer.commit()
    }
    
    
    // MARK: - Variable Declarations
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var measurementSelector: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var measurementReadingView: UIView!
    @IBOutlet weak var menubutton: UIButton!
    @IBOutlet weak var measurementReading: UILabel!
    @IBOutlet weak var connectionIcon: UIButton!
    @IBOutlet weak var metalView: MTKView!
    @IBOutlet weak var measurementChart: measurementChartView!
    @IBOutlet weak var timeDivisionLabel: UILabel!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var start_stopButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var yAxisDivisonLabel: UILabel!
    @IBOutlet weak var yAxisStepper: UIStepper!
    let primaryColor = UIColor(red: 0.1765, green: 0.3412, blue: 0.5294, alpha: 1.0) // The primary blue color the application uses.
    var bleManager : BluetoothConnectionManager!
    var start_stop : Bool = false
    var commandQueue: MTLCommandQueue!
    
    // MARK: - Action Outlets
    
    /**
     Action outlet that handles when the measurementSelector is changed.
     - Changes the appended unit to the data displayed on measurementReading.text
     */
    @IBAction func measurementSelectorChanged(_ sender: Any) {
        if measurementSelector.selectedSegmentIndex == 0 {
            self.measurementReading.text = "-- V"
            measurementChart.chartDataSet.label = "Voltage"
            yAxisDivisonLabel.text = String(format: "%d V", Int(yAxisStepper.value))
        } else if measurementSelector.selectedSegmentIndex == 1 {
            self.measurementReading.text = "-- A"
            measurementChart.chartDataSet.label = "Current"
            yAxisDivisonLabel.text = String(format: "%d A", Int(yAxisStepper.value))
        } else if measurementSelector.selectedSegmentIndex == 2 {
            self.measurementReading.text = "-- Ω"
            measurementChart.chartDataSet.label = "Resistance"
            yAxisDivisonLabel.text = String(format: "%d Ω", Int(yAxisStepper.value))
        }
    }
    
    /**
     Action outlet that handles when the timeDivisionStepper is tapped.
     - Changes the value of the timeDivisionLabel.
     - Changes the time divisions of the measurement graph.
    */
    @IBAction func timeStepperTapped(_ sender: UIStepper) {
        timeDivisionLabel.text = String(format: "%d ms", Int(sender.value))
        measurementChart.notifyDataSetChanged()
    }
    
    /**
     Action outlet that handles when the yAxisStepper is tapped.
     - Changes the value of the yAxisDivisionLabel.
     - Changes the y-Axis divisions of the measurement graph.
    */
    @IBAction func yAxisStepperTapped(_ sender: UIStepper) {
        if measurementSelector.selectedSegmentIndex == 0 {
            yAxisDivisonLabel.text = String(format: "%d V", Int(sender.value))
            measurementChart.leftAxis.axisMinimum = -1*(sender.value)
            measurementChart.rightAxis.axisMinimum = -1*(sender.value)
            measurementChart.leftAxis.axisMaximum = sender.value
            measurementChart.rightAxis.axisMaximum = sender.value
            measurementChart.notifyDataSetChanged()
        } else if measurementSelector.selectedSegmentIndex == 1 {
            yAxisDivisonLabel.text = String(format: "%d A", Int(sender.value))
            measurementChart.leftAxis.axisMinimum = -1*(sender.value)
            measurementChart.rightAxis.axisMinimum = -1*(sender.value)
            measurementChart.leftAxis.axisMaximum = sender.value
            measurementChart.rightAxis.axisMaximum = sender.value
            measurementChart.notifyDataSetChanged()
        } else {
            yAxisDivisonLabel.text = String(format: "%d Ω", Int(sender.value))
            measurementChart.leftAxis.axisMinimum = -1*(sender.value)
            measurementChart.rightAxis.axisMinimum = -1*(sender.value)
            measurementChart.leftAxis.axisMaximum = sender.value
            measurementChart.rightAxis.axisMaximum = sender.value
            measurementChart.notifyDataSetChanged()
        }
    }
    
    
    /**
    Action outlet that handles when the menu button is pressed.
    - Segues to the menuTableViewController which displays a table view of menu options.
    */
    @IBAction func menuButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "menuSegue", sender: sender)
    }
    
    /**
    Action outlet that handles when the connected icon is tapped.
    - Displays an alert that tells the user the state of the connection in English.
    */
    @IBAction func connectedIconTapped(_ sender: Any) {
        if bleManager.isConnected() {
            let alertController = UIAlertController(title: "Connected!", message:
                "A Bluemeter device is currently connected.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Not Connected", message:
                "A Bluemeter device is not connected.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /**
    Action outlet that handles the pressing of the snapshot button.
    - Displays a modal alert with a screenshot of the measurement graph in its current state.
    - Saves screenshot of graph to the users camera roll if "Yes" is selected.
    - Does nothing and closes alert when "No" is selected
     
     - Parameter sender: the snapshot button
    */
    @IBAction func snapshotButtonTapped(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: measurementChart.bounds.size)
        let image = renderer.image { ctx in
            measurementChart.drawHierarchy(in: measurementChart.bounds, afterScreenUpdates: true)
        }
        let imageView = UIImageView(frame: CGRect(x: 220, y: 10, width: 100, height: 100))
        imageView.image = image
        
        let titleAttrString = NSMutableAttributedString(string: "Save to photos?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        
        let alertController = UIAlertController(title: "", message:
            "", preferredStyle: .actionSheet)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        let alertControllerImageAction = UIAlertAction(title: "", style: .default, handler: nil)
        alertControllerImageAction.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        
        alertController.addAction(alertControllerImageAction)
        alertController.addAction(UIAlertAction(title: "No", style: .destructive))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
    Function that handles the pressing of the Start/Stop button
    - Toggles between displaying a blue play button or a red pause button.
    - Stops/Starts the retrival of data from the Bluemeter device.
    - Starts/Stops timer label
    */
    @IBAction func stopstartButtonPressed(_ sender: Any) {
        start_stopTimer()
        
        if start_stop == true{
            // Stop retrieving bluetooth data
            self.bleManager.stopGettingMeasurementData()
            self.start_stopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.start_stopButton.tintColor = self.primaryColor
            self.start_stop = false
        } else {
            // Start retrieving bluetooth data
            self.bleManager.startGettingMeasurementData()
            self.start_stopButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.start_stopButton.tintColor = .systemRed
            self.start_stop = true
        }
    }
    
    
    // MARK: - Initial Setup and UI Layout Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start BLE manager
        bleManager = BluetoothConnectionManager()
        
        // Metal view setup
        metalView.device = MTLCreateSystemDefaultDevice()
        if self.traitCollection.userInterfaceStyle == .dark {
            metalView.clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 0)
        } else {
            metalView.clearColor = MTLClearColorMake(255.0, 255.0, 255.0, 0)
        }
        metalView.enableSetNeedsDisplay = true
        metalView.delegate = self
        commandQueue = metalView.device?.makeCommandQueue()
        
        
        // Continously check every 2 seconds to see if we're still connected
        // to bluetooth or not, then update connected icon
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            self.setConnectionIcon()
        }
        
        // Set yAxis stepper min and max
        yAxisDivisonLabel.text = "10 V"
        yAxisStepper.minimumValue = 5
        yAxisStepper.maximumValue = 100
        yAxisStepper.stepValue = 5
        yAxisStepper.value = 10
        
        // Set time stepper min and max
        timeDivisionLabel.text = "1000 ms"
        timeStepper.minimumValue = 500
        timeStepper.maximumValue = 5000
        timeStepper.stepValue = 500
        timeStepper.value = 1000
        
        measurementChart.delegate = self
        measurementChart.setLineChart(axisMax: Double(yAxisStepper.value), label: "Voltage")
        timeLabel.text = "00:00:00"
    }
    
    /**
    Overriding viewDidLayoutSubviews to style the user interface after layout so that
    shadows and widths layout properly.
    */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        styleUI()
    }
    
    /**
    Overriding viewWillAppear to hide the navigation bar on load.
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    /**
    Overriding viewWillDisappear to display the navigation bar on navigation away from this view controller.
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /**
    Pepare for segue to the next view controller.
    - Passes the BluetoothConnectionManager instance to the next view controller.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuSegue" {
            let destinationVC = segue.destination as? menuTableViewController
            destinationVC?.bleManager = self.bleManager
        }
    }
    
    /**
    Function that sets styling of the view controllers UI components.
    */
    func styleUI() {
        measurementReadingView.layer.cornerRadius = 5
        measurementReadingView.layer.shadowColor = UIColor.darkGray.cgColor
        measurementReadingView.layer.shadowOffset = CGSize(width: 0, height: 2)
        measurementReadingView.layer.shadowRadius = 1
        measurementReadingView.layer.shadowOpacity = 0.4
        
        measurementChart.layer.masksToBounds = true
        measurementChart.layer.cornerRadius = 5
        
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOpacity = 0.4
        
        menubutton.tintColor = primaryColor
        titleLabel.textColor = primaryColor
        
        measurementSelector.selectedSegmentTintColor = primaryColor
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        measurementSelector.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        setConnectionIcon()
    }
    
    /**
    Sets the connectionIcon based on whether the apllication is connected to a Bluemeter device or not.
    - Displays a blue check when connected.
    - Displays a red warning sign when not connected.
    */
    func setConnectionIcon() {
        if self.bleManager.isConnected() {
            self.connectionIcon.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
            self.connectionIcon.tintColor = self.primaryColor
        } else {
            self.connectionIcon.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
            self.connectionIcon.tintColor = UIColor.red
        }
    }
    
    /**
        Function that starts and stops the Timer for the time label.
     */
    func start_stopTimer() {
        if !start_stop {
            timeLabel.text = "00:00:00"
            resetMeasurementChart()
        }
        
        let startTime = Date().timeIntervalSinceReferenceDate
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { timer in
            if self.start_stop {
                self.updateTime(start: startTime)
            } else {
                timer.invalidate()
            }
        })
    }
    
    func updateTime(start: TimeInterval) {
        // Total time since timer started, in seconds
        let time = Date().timeIntervalSinceReferenceDate - start
        var minutes : Int = Int(time) / 60
        minutes = minutes >= 60 ? 0 : minutes
        let seconds : Int = Int(time) >= 60 ? Int(time) % 60 : Int(time)
        var milliseconds = String(format: "%.2f", time.truncatingRemainder(dividingBy: 1))
        milliseconds.removeFirst()
        milliseconds.removeFirst()
        
        // Display the time string to a label in our view controller
        self.timeLabel.text = String(format: "%.2d:%.2d:%.2d", minutes, seconds, Int(milliseconds)!)
        // Display mesurement
        let measurement = processBluetoothData(dataString: bleManager.getData())
        updateMeasurementReading(measurement: measurement)
        let newDataEntry = ChartDataEntry(x: time/timeStepper.value*1000, y: measurement)
        self.measurementChart.updateChartView(with: newDataEntry, dataEntries: &self.measurementChart.chartDataEntry)
    }
    
    /**
        Function that resets the measurement chart.
     */
    func resetMeasurementChart() {
        measurementChart.delegate = self
        measurementChart.chartData?.notifyDataChanged()
        measurementChart.clear()
        measurementChart.chartDataEntry.removeAll(keepingCapacity: false)
        measurementChart.notifyDataSetChanged()
        measurementChart.setLineChart(axisMax: Double(yAxisStepper.value), label: getSelectedMeasurement())
        measurementChart.moveViewToX(Double(measurementChart.chartDataEntry.count))
        while !measurementChart.isFullyZoomedOut {
            measurementChart.zoomOut()
        }
    }
    
    /**
        Function that gets the measurement selected by the mesurement selector.
     */
    func getSelectedMeasurement() -> String {
        if measurementSelector.selectedSegmentIndex == 0 {
            return "Voltage"
        } else if measurementSelector.selectedSegmentIndex == 1 {
            return "Current"
        } else {
            return "Resistance"
        }
    }
    
    /**
        Function that updates the measurement reading label each time it's called.
        - Parameter measurement: A floating point value of the passed in measurement.
     */
    func updateMeasurementReading(measurement: Double) {
        if measurementSelector.selectedSegmentIndex == 0 {
            measurementReading.text = String(format: "%.2f V", measurement)
        } else if measurementSelector.selectedSegmentIndex == 1 {
            measurementReading.text = String(format: "%.2f A", measurement)
        } else {
            measurementReading.text = String(format: "%.2f Ω", measurement)
        }
    }
    
    /**
        Function that parses the data obtained from the bluetooth communication.
     */
    func processBluetoothData(dataString: String) -> Double {
        if dataString.contains("|") {
            let strArr = dataString.components(separatedBy: ["|"])
            let processedResult : Double = (strArr[1] as NSString).doubleValue
            return processedResult / 1000
        } else {
            return 0.0
        }
    }
}

