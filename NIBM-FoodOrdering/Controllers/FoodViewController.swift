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
    
    @IBOutlet weak var discountLabel: UILabel!
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
        loadCategories()
        loadFood()
    }
    
    func loadCategories()
    {
        categories = []
        
        db.collection(K.fire.categoryCollection).addSnapshotListener{(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                self.categories.removeAll()
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let catName = data[K.fire.catName] as? String, let ID = doc.documentID as? String
                        {
                            let newCat = Category(name: catName, catId: ID)
                            self.categories.append(newCat)
                            DispatchQueue.main.async {
                                self.foodTableView.reloadData()
                            }
                            
                        }
                    }
                    
                    
                    
                }
            }
        }
    }
    
    func loadFood()
    {
        foods = []
        
        db.collection(K.fire.foodColection).addSnapshotListener{(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data.  \(e)")
            }
            else{
                self.foods.removeAll()
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument {
                        let data = doc.data()
                        if let  foodName = data[K.fire.foodName] as? String, let foodPrice = data[K.fire.foodPrice] as? String, let foodDescription = data[K.fire.foodDescription] as? String, let foodCatID = data[K.fire.foodCatID] as? String, let FoodCatType = data[K.fire.FoodCatType] as? String, let discount = data[K.fire.discount] as? String
                        {
                            let newFood = Food(title: foodName, uprice: foodPrice, description: foodDescription, type: FoodCatType, category: foodCatID,discount: discount)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        var filterArr: [Food] = []
        filterArr = foods.filter{($0.type.contains(categories[section].name))}
        
        return filterArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var filterArr: [Food] = []
        filterArr = foods.filter{($0.type.contains(categories[indexPath.section].name))}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MyCustomCell
        cell.FoodNameLabel.text = filterArr[indexPath.row].title
        cell.FoodPriceLabel.text = "\(filterArr[indexPath.row].uprice)"
        if filterArr[indexPath.row].discount != "0"
        {
            cell.discountLabel.text = "-\(filterArr[indexPath.row].discount)%"
        }
        else
        {
            cell.discountLabel.isHidden=true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return categories[section].name
      }
    
    
}

extension FoodViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  next = (storyboard?.instantiateViewController(identifier: "FoodDetailViewController") as! FoodDetailViewController)
        self.navigationController?.pushViewController(next, animated: true)
        
        var filterArr: [Food] = []
        filterArr = foods.filter{($0.type.contains(categories[indexPath.section].name))}
        let foo = filterArr[indexPath.row]
        next.name=foo.title
        next.price=foo.uprice
        next.desc=foo.description
    }
    
}
