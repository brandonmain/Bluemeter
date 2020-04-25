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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "devicesSegue" {
            let destinationVC = segue.destination as? devicesTableViewController
            destinationVC?.bleManager = self.bleManager
        }
    }
}
