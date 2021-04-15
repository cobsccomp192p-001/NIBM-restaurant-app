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
        
        let catName = txtName.text
        
        var ref: DocumentReference? = nil
        ref = db.collection("categories").addDocument(data: [
            "name": catName as Any
            
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
//                DispatchQueue.main.async {
//                    self.categoryTableView.reloadData()
//                }
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        self.categories.removeAll()
        categoryTableView.reloadData()
        txtName.text=""
        
        
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
//                self.Items.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
//                self.Items.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            deleteAction.image = UIImage(named: "delete")
            deleteAction.backgroundColor = .red
            return [deleteAction]
        }
    
    
}
extension NewCategoryViewController:UITableViewDelegate{
    
    
    
}
