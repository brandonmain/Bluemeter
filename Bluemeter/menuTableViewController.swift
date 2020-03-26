//
//  menuTableViewController.swift
//  Bluemeter
//
//  Created by Brandon Main on 12/27/19.
//  Copyright © 2019 Brandon Main. All rights reserved.
//

import UIKit

class menuTableViewController: UITableViewController {
    
    //MARK:- Variable declarations
    let menuItems : [String] = ["Devices"]
    var bleManager : BluetoothConnectionManager!
    
    @IBOutlet var menuTableView: UITableView!
    
    // MARK: - Initial Setup and UI Layout
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false
        
        // Initial table setup
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        //self.navigationController?.navigationBar.tintColor = UIColor.link
    }
    
    
    // Overriding this function to make status bar white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Table View methods

    // Set number of table sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Set number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    // Instansiate cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

        performSegue(withIdentifier: "devicesSegue", sender: cell)
    }
    
    // MARK: - Optional Table View methods


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

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "devicesSegue" {
            let destinationVC = segue.destination as? devicesTableViewController
            destinationVC?.bleManager = self.bleManager
        }
    }
}
