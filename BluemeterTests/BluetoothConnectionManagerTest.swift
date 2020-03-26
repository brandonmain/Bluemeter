//
//  BluetoothConnectionManagerTest.swift
//  BluemeterTests
//
//  Created by Brandon Main on 1/25/20.
//  Copyright © 2020 Brandon Main. All rights reserved.
//

import XCTest
@testable import Bluemeter

class BluetoothConnectionManagerTest: XCTestCase {

   // var app: XCUIApplication!
    var bleConnectionManagerTestObject: BluetoothConnectionManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        bleConnectionManagerTestObject = BluetoothConnectionManager()
        
    }
    
    func testIsConnected() {
        if bleConnectionManagerTestObject.isConnected() == true {
            XCTAssertTrue(bleConnectionManagerTestObject.isConnected())
        } else {
            XCTAssertFalse(bleConnectionManagerTestObject.isConnected())
        }
    }
    
    func testConnectIndexValue() {
        bleConnectionManagerTestObject.connect(index: -1)
        XCTAssertFalse(bleConnectionManagerTestObject.isConnected())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
