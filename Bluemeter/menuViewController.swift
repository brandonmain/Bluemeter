//
//  menuViewController.swift
//  Bluemeter
//
//  Created by Brandon Main on 12/23/19.
//  Copyright © 2019 Brandon Main. All rights reserved.
//

import UIKit

class menuViewController: UIViewController {

    @IBOutlet var menuContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //setContainerView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 
    
    // Function that sets the rounding and shadow
    // of the contianer view
    func setContainerView() {
        menuContainerView.layer.cornerRadius = 10
        menuContainerView.layer.cornerRadius = 10
        menuContainerView.layer.shadowColor = UIColor.black.cgColor
        menuContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuContainerView.layer.shadowRadius = 10
        menuContainerView.layer.shadowOpacity = 0.8
        menuContainerView.layer.shadowPath = UIBezierPath(roundedRect: menuContainerView.bounds, cornerRadius: 10).cgPath
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
