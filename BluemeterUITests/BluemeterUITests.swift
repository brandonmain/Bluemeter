//
//  BluemeterUITests.swift
//  BluemeterUITests
//
//  Created by Brandon Main on 1/25/20.
//  Copyright © 2020 Brandon Main. All rights reserved.
//

import XCTest

class BluemeterUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // rootViewController UI Elements
    var menuButton: XCUIElement!
    var connectionIndicator: XCUIElement!
    var title: XCUIElement!
    var segmentedButtonVoltage: XCUIElement!
    var segmentedButtonCurrent: XCUIElement!
    var segmentedButtonResistance: XCUIElement!
    var snapshotButton: XCUIElement!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        menuButton = app.buttons["line.horizontal.3"]
        connectionIndicator = app.buttons["exclamationmark.triangle"]
        title = app.staticTexts["Bluemeter"]
        segmentedButtonVoltage = app.buttons["Voltage"]
        segmentedButtonCurrent = app.buttons["Current"]
        segmentedButtonResistance = app.buttons["Resistance"]
        snapshotButton = app.buttons["largecircle.fill.circle"]
        app.launch()
        

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitialContentDisplays() {
        XCTAssertTrue(menuButton.exists)
        XCTAssertTrue(connectionIndicator.exists)
        XCTAssertTrue(title.exists)
        XCTAssertTrue(segmentedButtonVoltage.exists)
        XCTAssertTrue(segmentedButtonCurrent.exists)
        XCTAssertTrue(segmentedButtonResistance.exists)
        XCTAssertTrue(snapshotButton.exists)
    }

    func testSegmentedMeasurementChangesMesurementReadingLabel() {
        app.buttons["Voltage"].tap()
        XCTAssertTrue(app.staticTexts["-- V"].exists)
        app.buttons["Current"].tap()
        XCTAssertTrue(app.staticTexts["-- A"].exists)
        app.buttons["Resistance"].tap()
        XCTAssertTrue(app.staticTexts["-- Ω"].exists)
    }
    
    func testPressingSnapshotButtonMakesAlert() {
        snapshotButton.tap()
        XCTAssertTrue(app.sheets.scrollViews.otherElements.buttons["No"].exists)
        XCTAssertTrue(app.sheets.scrollViews.otherElements.buttons["Yes"].exists)
        XCTAssertTrue(app.sheets.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .scrollView).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.exists)
    }
    
    func testPressingNoOnSnapshotButtonAlertRemovesAlert() {
        snapshotButton.tap()
        app.sheets.scrollViews.otherElements.buttons["No"].tap()
        XCTAssertFalse(app.sheets.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .scrollView).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.exists)
    }
    
    func testPressingYesOnSnapshotButtonAlertRemovesAlert() {
        snapshotButton.tap()
        app.sheets.scrollViews.otherElements.buttons["Yes"].tap()
        XCTAssertFalse(app.sheets.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .scrollView).element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.exists)
    }
    
    func testPressingMenuButtonNavigatestoMenu() {
        app.buttons["line.horizontal.3"].tap()
        XCTAssertTrue(app.navigationBars["Menu"].buttons["Back"].exists)
    }
    
    func testPressingDevicesNavigatesToDevices() {
        
    }
}
