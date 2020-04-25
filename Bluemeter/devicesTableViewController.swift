//
//  devicesTableViewController.swift
//  Bluemeter
//
//  Created by Brandon Main on 1/13/20.
//  Copyright © 2020 Brandon Main. All rights reserved.
//

import UIKit

class devicesTableViewController: UITableViewController {

    // MARK: - Variable Declarations
    @IBOutlet var devicesTableView: UITableView!
    public var bleManager : BluetoothConnectionManager!
    
    // MARK: - Initial Setup and UI Layout
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial table setup
        devicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "devicesId")
        devicesTableView.delegate = self
        devicesTableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(scanForDevices), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bleManager.scannedBLEDevices.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "devicesId", for: indexPath)
        
        cell.textLabel?.text = bleManager.scannedBLEDevices[indexPath.row].name
        
        return cell
    }
    
    // BLE Peripheral tapped, attempt to connect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bleManager?.connect(index: indexPath.row)
    }
    
    /**
        Function that scans for more BLE devices when the table upper bound is scrolled.
     */
    @objc func scanForDevices() {
        self.bleManager.startScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
}
