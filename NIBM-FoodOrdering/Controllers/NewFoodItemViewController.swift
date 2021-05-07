//
//  NewFoodItemViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/16/21.
//

import UIKit
import Firebase

class NewFoodItemViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    
    
    
    @IBOutlet weak var FoodName: UITextField!
    @IBOutlet weak var Description: UITextField!
    @IBOutlet weak var Discount: UITextField!
    @IBOutlet weak var Categories: UITextField!
    @IBOutlet weak var Price: UITextField!
    @IBOutlet weak var CatId: UITextField!
    
    let db = Firestore.firestore()
    var categoriesArr: [Category] = []
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        loadCategories()
        // Do any additional setup after loading the view.
    }
    let pickerView = UIPickerView()
    func createPickerView() {
           
           pickerView.delegate = self
           Categories.inputView = pickerView
        
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        Categories.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }
    
    func loadCategories()
    {
        categoriesArr = []
        
        db.collection(K.fire.categoryCollection).getDocuments{(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let catName = data[K.fire.catName] as? String, let ID = doc.documentID as? String
                        {
                            let newCat = Category(name: catName, catId: ID)
                            self.categoriesArr.append(newCat)
                            
                            DispatchQueue.main.async {
                                self.pickerView.reloadAllComponents()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesArr[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedCategory = categoriesArr[row].name // selected item
        Categories.text = selectedCategory
        CatId.text = categoriesArr[row].catId
        
    }
    
    @IBAction func btnFood(_ sender: RoundedButton) {
        let foodName = FoodName.text
        let description = Description.text
        let discount = Discount.text
        let category = Categories.text
        let price = Price.text
        let catId = CatId.text
       
        if foodName!.isEmpty || description!.isEmpty || discount!.isEmpty || category!.isEmpty || price!.isEmpty
        {
            AlertMesg(msg: "Enter all fields")
        }
        else{
        var ref: DocumentReference? = nil
        ref = db.collection("FoodItems").addDocument(data: [
            "name": foodName as Any,
            "Description": description as Any,
            "price": price as Any,
            "type": category as Any,
            "category":catId as Any,
            "discount":discount as Any
            
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                self.FoodName.text = ""
                self.Description.text = ""
                self.Discount.text = ""
                self.Categories.text = ""
                self.Price.text = ""
                self.CatId.text = ""
                
                self.AlertMesg(msg: "Data added successfully")
            }
        }
        }
    }
    func AlertMesg(msg:String)
    {
        let dialogMessage = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(ok)
         
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
    
