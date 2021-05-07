//
//  ForgotPassViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 5/8/21.
//

import UIKit
import Firebase
class ForgotPassViewController: UIViewController {

    
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetPassBtn(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
            if let error=error{
                self.AlertMesg(msg: error.localizedDescription)
            }
            else{
                self.AlertMesg(msg: "Password Reset email has been sent")
                
            }
        }
    }
    func AlertMesg(msg:String)
    {
        let dialogMessage = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            self.navigationController?.popViewController(animated: true)

        })
        dialogMessage.addAction(ok)
         
        self.present(dialogMessage, animated: true, completion: nil)
    }
    

}
