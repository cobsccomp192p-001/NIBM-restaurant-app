//
//  AccountViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func LogoutBtn(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    

}
