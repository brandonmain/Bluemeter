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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
    
    // BLE Peripheral tapped, atempt to connect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.bleManager?.connect(index: indexPath.row)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func scanForDevices() {
        self.bleManager.startScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

}
