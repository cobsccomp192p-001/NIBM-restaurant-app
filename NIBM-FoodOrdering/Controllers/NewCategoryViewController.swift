//
//  NewCategoryViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/14/21.
//

import UIKit
import Firebase

class MyCustomCell2: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
}

class NewCategoryViewController: UIViewController {
    let db = Firestore.firestore()
    var categories: [Category] = []

    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBAction func btnAdd(_ sender: RoundedButton) {
        
        if txtName.text!.isEmpty{
            AlertMesg(msg: "Enter all fieldss")
        }
        else{
        let catName = txtName.text
        
        var ref: DocumentReference? = nil
        ref = db.collection("categories").addDocument(data: [
            "name": catName as Any
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.AlertMesg(msg: "Data added successfully")
            }
        }
        self.categories.removeAll()
        categoryTableView.reloadData()
        txtName.text=""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.dataSource=self
        categoryTableView.delegate=self
        loadCategories()
    }
    
    func loadCategories()
    {
        db.collection(K.fire.categoryCollection).addSnapshotListener{(documentSnapshot, error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                if let snapshotDocument = documentSnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let catName = data[K.fire.catName] as? String, let ID = doc.documentID as? String
                        {
                            let newCat = Category(name: catName, catId: ID)
                            self.categories.append(newCat)
                            
                            DispatchQueue.main.async {
                                self.categoryTableView.reloadData()
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func deleteCategory(index: Int)
    {
        let alert = UIAlertController(title: "Reject", message: "Are you sure you wanna Delete?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {_ in
           
            self.db.collection("categories").document(self.categories[index].catId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    
                }
            }
            self.categories.removeAll()
            self.categoryTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    func AlertMesg(msg:String)
    {
        let dialogMessage = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(ok)
         
        self.present(dialogMessage, animated: true, completion: nil)
    }
  
    

}
extension NewCategoryViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier2, for: indexPath) as! MyCustomCell2
        cell.lblName.text = categories[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, complete in
                
                self.deleteCategory(index: indexPath.row)
                complete(true)
            }
        
            deleteAction.image = UIImage(named: "delete")
            deleteAction.backgroundColor = .red
            
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UIContextualAction]? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _,_  in

                self.deleteCategory(index: indexPath.row)
            }
            deleteAction.image = UIImage(named: "delete")
            deleteAction.backgroundColor = .red
            return [deleteAction]
        }
    
    
}

extension NewCategoryViewController:UITableViewDelegate{
    
    
    
}

