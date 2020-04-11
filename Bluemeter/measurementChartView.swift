//
//  measurementChartView.swift
//  Bluemeter
//
//  Created by Brandon Main on 1/16/20.
//  Copyright © 2020 Brandon Main. All rights reserved.
//

import UIKit
import Charts
import MetalKit

class measurementChartView: LineChartView {
    
    var chartDataEntry : [ChartDataEntry] = []
    var time : [String] = []
    var measurements : [String] = []
    var chartData : LineChartData!
    var chartDataSet : LineChartDataSet!
    
    func setLineChart(axisMax : Double, label : String) {
        self.xAxis.removeAllLimitLines()
        self.noDataText = "No data"
        self.noDataTextColor = UIColor.black
        self.xAxis.drawLabelsEnabled = false
        self.xAxis.drawAxisLineEnabled = false
        self.leftAxis.drawLabelsEnabled = true
        self.leftAxis.drawAxisLineEnabled = false
        self.rightAxis.drawLabelsEnabled = false
        self.rightAxis.drawAxisLineEnabled = false
        self.leftAxis.drawZeroLineEnabled = true
        self.leftAxis.zeroLineWidth = 3
        self.leftAxis.axisMinimum = -1*(axisMax)
        self.leftAxis.axisMaximum = axisMax
        self.rightAxis.axisMinimum = -1*(axisMax)
        self.rightAxis.axisMaximum = axisMax
        self.leftAxis.labelCount = 4
        self.rightAxis.labelCount = 4
        self.rightAxis.enabled = true
        self.xAxis.labelCount = 0
        self.setVisibleXRangeMaximum(2.0)
        self.pinchZoomEnabled = false
        self.doubleTapToZoomEnabled = false
        self.xAxis.avoidFirstLastClippingEnabled = true
        self.leftAxis.labelTextColor = UIColor.label
        self.legend.textColor = UIColor.label
        
        chartDataSet = LineChartDataSet(entries: chartDataEntry, label: label)
        chartDataSet.setColor(UIColor(red: 0.1765, green: 0.3412, blue: 0.5294, alpha: 1.0))
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.lineWidth = 1
        chartDataSet.axisDependency = .right
        
        
        chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.notifyDataChanged()
        self.notifyDataSetChanged()
        chartData.setDrawValues(false)
        
        self.data = chartData
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if dataEntries.count > 0 {
            if newDataEntry.x < dataEntries[dataEntries.count-1].x {
                newDataEntry.x += dataEntries[dataEntries.count-1].x - newDataEntry.x
            }
        }
        dataEntries.append(newDataEntry)
        self.data?.addEntry(newDataEntry, dataSetIndex: 0)
        self.data?.notifyDataChanged()
        self.notifyDataSetChanged()
        self.moveViewToX(newDataEntry.x)
        self.setVisibleXRangeMaximum(2.0)
    }
}
