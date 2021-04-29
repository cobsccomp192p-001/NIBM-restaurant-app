//
//  OrderViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/4/21.
//

import UIKit
import Firebase

class MyCustomCell3: UITableViewCell{
    
    
    @IBOutlet weak var btnAdd: RoundedButton!
    @IBOutlet weak var cusNameLabel: UILabel!
    
    @IBOutlet weak var btnStatus: RoundedButton!
    @IBOutlet weak var btnReject: RoundedButton!
    @IBOutlet weak var orderIdLabel: UILabel!
}

class OrderViewController: UIViewController {

    let db = Firestore.firestore()
    var orders: [Orders] = []
    
    @IBOutlet weak var orderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        orderTableView.dataSource=self
        orderTableView.delegate=self
        loadOrders()
        
    }
    
    func loadOrders(){
        
        orders = []
        db.collection("orderList").getDocuments(){(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let cusName = data[K.orderList.cusName] as? String, let orderID = data[K.orderList.orderID] as? String, let status = data[K.orderList.status] as? String, let statusName = data[K.orderList.statusName] as? String
                        {
                            
                            let newOrder = Orders(cusName: cusName, status: status, orderID: orderID, statusName: statusName)
                            self.orders.append(newOrder)
                            
                            DispatchQueue.main.async {
                                self.orderTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
    }

        

}

extension OrderViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier3, for: indexPath) as! MyCustomCell3
        cell.cusNameLabel.text = orders[indexPath.row].cusName
        cell.orderIdLabel.text = orders[indexPath.row].orderID
        cell.btnStatus.setTitle(orders[indexPath.row].statusName, for: .normal
        )
        cell.btnAdd.isHidden=true
        cell.btnReject.isHidden=true
        if orders[indexPath.row].status == "1"
        {
            cell.btnAdd.isHidden=false
            cell.btnReject.isHidden=false
        }
        
        
        return cell
    }
    
    
}

extension OrderViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  next = (storyboard?.instantiateViewController(identifier: "OrderDetailViewController") as! OrderDetailViewController)

        self.navigationController?.pushViewController(next, animated: true)
        let order = orders[indexPath.row]
        
        next.cusname=order.cusName
        next.orderID=order.orderID
        next.status=order.statusName
        
    }
    
}
