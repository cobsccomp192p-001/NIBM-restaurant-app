
import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var MobileTextField: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty || MobileTextField.text!.isEmpty
        {
            AlertMesg(msg: "Enter all fieldss")
        }
        else{
            if let email = emailTextfield.text, let password = passwordTextfield.text{
        
                Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                    if let e=error
                    {
                        ErrAlertMesg(error: e.localizedDescription)
                    }
                    else
                    {
                        if let Mobile = MobileTextField.text,let currUser = Auth.auth().currentUser?.uid {
                            
                            db.collection(K.fire.userCollection).addDocument(data: [
                                K.fire.uid: currUser,
                                "mobile": Mobile
                            
                            ]) { (error) in
                                if let e = error{
                                    
                                    ErrAlertMesg(error: e.localizedDescription)
                                }
                                else{
                                    
                                    AlertMesg(msg: "Data saved successfully")
                                }
                            }
                            
                        }
                        self.performSegue(withIdentifier: K.registerSegue, sender: self)
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

extension String {
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^d{10}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}
