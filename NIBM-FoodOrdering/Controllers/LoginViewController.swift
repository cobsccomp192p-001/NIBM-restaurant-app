
import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func forgotpassBtn(_ sender: Any) {
        self.performSegue(withIdentifier: K.forgotSegue, sender: self)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty
        {
            AlertMesg(msg: "Enter all fields")
            
        }
        else
        {
            if let email = emailTextfield.text, let password = passwordTextfield.text
            {
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
              
                if let e=error
                {
                    self.ErrAlertMesg(error: e.localizedDescription)
                }
                else
                {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
                    
                }
            }
        }
        
        
    }
    
    func ErrAlertMesg(error:String)
    {
        let dialogMessage = UIAlertController(title: "Alert", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        dialogMessage.addAction(ok)
         
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func AlertMesg(msg:String)
    {
        let dialogMessage = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(ok)
         
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
