//
//  BluetoothConnectionManager.swift
//  Bluemeter
//
//  Created by Brandon Main on 4/11/20.
//  Copyright © 2020 Brandon Main. All rights reserved.
//

import UIKit
import CoreBluetooth

class BluetoothConnectionManager : NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    public static let bleServiceUUID = CBUUID.init(string: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFF0000")
    public static let bleVoltageCharacteristicUUID = CBUUID.init(string: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFF0001")
    
    // Array to contain names of BLE devices to connect to.
    public var scannedBLEDevices: [CBPeripheral] = []
    
    public var retrievingData : Bool = false
    
    private var data : String?
    
    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager.state)")
        DispatchQueue.global().async {
            self.centralManagerDidUpdateState(self.centralManager)
        }
    }
    
    
    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unsupported:
            print("BLE is Unsupported")
            break
        case .unauthorized:
            print("BLE is Unauthorized")
            break
        case .unknown:
            print("BLE is Unknown")
            break
        case .resetting:
            print("BLE is Resetting")
            break
        case .poweredOff:
            print("BLE is Powered Off")
            break
        case .poweredOn:
            print("Central scanning for", BluetoothConnectionManager.bleServiceUUID);
            DispatchQueue.main.async {
                self.startScan()
            }
            break
        @unknown default:
            print("BLE is Unknown")
        }
    }
    
    
    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        self.peripheral = peripheral
        
        // Make sure not to add duplicates
        if peripheral.name != nil {
            var found = false
            var i = 0
            for identifier in scannedBLEDevices {
                if identifier.name == peripheral.name {
                    found = true
                    scannedBLEDevices[i] = peripheral
                    break
                }
                i += 1
            }
            if found == false {
                self.scannedBLEDevices.append(peripheral)
            }
        }
    }
    
    
    // The handler if we do connect successfully
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your BLE Board")
            peripheral.delegate = self
            peripheral.discoverServices([BluetoothConnectionManager.bleServiceUUID])
            print(peripheral)
            self.showAlertMessage(title: "Connected!", msg: "You have connected to \(self.peripheral.name!)")
        } else {
            self.showAlertMessage(title: "Could not connect", msg: "Unable to connect to this device, please try again.")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print(services)
                //Now kick off discovery of characteristics
                DispatchQueue.main.async {
                    peripheral.discoverCharacteristics([BluetoothConnectionManager.bleVoltageCharacteristicUUID], for: service)
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == BluetoothConnectionManager.bleVoltageCharacteristicUUID {
                    // Reading voltage characterisic
                    DispatchQueue.main.async {
                        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
                            peripheral.readValue(for: characteristic)
                            if let string = String(data: characteristic.value!, encoding: .ascii) {
                                self.data = string
                            } else {
                                print("not a valid UTF-8 sequence")
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    // Function to check if a peripheral is connected or not
    public func isConnected() -> Bool {
        // Connected
        if peripheral != nil {
            if peripheral.state.rawValue == 2 {
                return true
            } else { // Not Connected
                return false
            }
        } else {
            return false
        }
    }
    
    // Stops the scanning for peripherals
    @objc private func cancelScan() {
        self.centralManager?.stopScan()
    }
    
    // Starts the scanning for peripherals for 1 sec then stops
    @objc public func startScan() {
        scannedBLEDevices.removeAll()
        self.centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) {_ in
            self.cancelScan()
        }
    }
    
    // Attempts to connect to a peripheral specified at the passed in index
    // of scannedBLEDevices
    public func connect(index : Int) {
        // Make sure index is within limit of scanned devices
        if index < 0 || index > scannedBLEDevices.count {
            print("Index out of range of scanned devices")
            return
        } else if peripheral != nil {
            centralManager?.cancelPeripheralConnection(peripheral)
            self.peripheral = scannedBLEDevices[index]
            self.centralManager.connect(scannedBLEDevices[index], options: nil)
            print("connecting to: ", scannedBLEDevices[index].name!)
        }
    }
    
    // Called to START retrieving measurement data from device
    public func startGettingMeasurementData() {
        retrievingData = true
    }
    
    // Called to STOP retrieving measurement data from device
    public func stopGettingMeasurementData() {
        retrievingData = false
    }
    
    public func showAlertMessage(title: String, msg: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    /**
     Function that returns data received from bluetooth device.
     */
    public func getData() -> String {
        return self.data ?? ""
    }
}

