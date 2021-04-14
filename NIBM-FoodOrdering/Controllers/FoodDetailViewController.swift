//
//  FoodDetailViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

import UIKit

class FoodDetailViewController: UIViewController {
    var name = ""
    var price:Float=0.0
    var desc=""
    
    @IBOutlet weak var temp: UILabel!
    
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleLabel.text = name
        priceLabel.text = "\(price)"
        descLabel.text=desc
        
    }
    

    

}
