//
//  FoodViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

import UIKit
import Firebase


class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var FoodNameLabel: UILabel!
    
    @IBOutlet weak var FoodPriceLabel: UILabel!
}

class FoodViewController: UIViewController {

    @IBOutlet weak var foodTableView: UITableView!
    let db = Firestore.firestore()
    
    var foods: [Food] = []
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton=true
        foodTableView.dataSource=self
        foodTableView.delegate=self
        loadFood()
        loadCategories()
    }
    func loadCategories()
    {
        categories = []
        
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
                            self.categories.append(newCat)
                        }
                    }
                }
            }
        }
    }
    
    func loadFood()
    {
        foods = []
        
        db.collection(K.fire.foodColection).getDocuments{(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data.  \(e)")
            }
            else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let  foodName = data[K.fire.foodName] as? String, let foodPrice = data[K.fire.foodPrice] as? String, let foodDescription = data[K.fire.foodDescription] as? String, let foodCatID = data[K.fire.foodCatID] as? String, let FoodCatType = data[K.fire.FoodCatType] as? String
                        {
                            let newFood = Food(title: foodName, uprice: foodPrice, description: foodDescription, type: FoodCatType, category: foodCatID)
                            self.foods.append(newFood)
                            
                            DispatchQueue.main.async {
                                self.foodTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

}

extension FoodViewController:UITableViewDataSource{
    
//    func getCategoryName(index: Int) -> String
//    {
//        let catName=categories[index].name
//        return catName
//    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//            return categories.count
//        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return getCategoryName(index: section)
//      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let filterData = foods.filter({$0.type == getCategoryName(index: indexPath.section)})
//        let foodDetails = filterData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MyCustomCell
        cell.FoodNameLabel.text = foods[indexPath.row].title
        cell.FoodPriceLabel.text = "\(foods[indexPath.row].uprice)"
        return cell
    }
    
    
}

extension FoodViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  next = (storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as! FoodDetailViewController)
        
        self.navigationController?.pushViewController(next, animated: true)
        let foo = foods[indexPath.row]
        next.name=foo.title
        next.price=foo.uprice
        next.desc=foo.description
    }
    
}
