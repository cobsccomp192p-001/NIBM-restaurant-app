//
//  OrderDetailViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/28/21.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    var cusname = ""
    var orderID = ""
    var status = ""
   

    @IBOutlet weak var cusNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cusNameLabel.text = cusname
        orderIdLabel.text = orderID
        statusLabel.text = status
        
        // Do any additional setup after loading the view.
    }
    


}
