//
//  menuViewController.swift
//  Bluemeter
//
//  Created by Brandon Main on 12/22/19.
//  Copyright © 2019 Brandon Main. All rights reserved.
//

import UIKit

class mainViewController: UIViewController {
    
    // MARK: - Variable Declarations
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet weak var measurementReadingView: UIView!
    
    // MARK: - Action Methods
    
    // Segues to MenuTableViewController on click
    @IBAction func menuButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "menuSegue", sender: sender)
    }
    
    
    // MARK: - Initial Setup and UI Layout Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Hide Navigation bar when this view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // Show navigation bar when this view disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainContainerView.layer.masksToBounds = false
        mainContainerView.layer.cornerRadius = 10
        mainContainerView.layer.shadowColor = UIColor.black.cgColor
        mainContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainContainerView.layer.shadowRadius = 10
        mainContainerView.layer.shadowOpacity = 0.9
        mainContainerView.layer.shadowPath = UIBezierPath(roundedRect: mainContainerView.bounds, cornerRadius: 10).cgPath
        setMeasurementReadingView()
    }
    
    // Function that sets the rounding and shadow
    // of the measurementReadingView
    func setMeasurementReadingView() {
        measurementReadingView.layer.cornerRadius = 3
        measurementReadingView.layer.shadowColor = UIColor.darkGray.cgColor
        measurementReadingView.layer.shadowOffset = CGSize(width: 0, height: 0)
        measurementReadingView.layer.shadowRadius = 1
        measurementReadingView.layer.shadowOpacity = 1
    }
    
}
