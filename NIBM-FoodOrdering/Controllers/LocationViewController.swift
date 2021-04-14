//
//  LocationViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/4/21.
//

import UIKit

class LocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }
    

    @IBAction func btnLocation(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "LocationToOrder", sender: self)
        
    }
    

}
