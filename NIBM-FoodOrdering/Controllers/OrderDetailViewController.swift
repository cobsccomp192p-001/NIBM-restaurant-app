//
//  OrderDetailViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/28/21.
//

import UIKit
import Firebase

class MyCustomCell4: UITableViewCell{
    
    @IBOutlet weak var foodNameLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var unitPriceLabel: UILabel!
}

class OrderDetailViewController: UIViewController {
    
    let db = Firestore.firestore()
    var cusname = ""
    var orderID = ""
    var status = ""
    var netAmount = ""
    var statusID = ""
    var docID = "" 
    var orderDet: [OrderItemInfo] = []
   
    @IBOutlet weak var netAmountLabel: UILabel!
    @IBOutlet weak var orderDetail: UITableView!
    @IBOutlet weak var cusNameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var btnDone: RoundedButton!
    @IBOutlet weak var btnReady: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnReady.isHidden = true
        btnDone.isHidden = true
        
        if statusID == "2"
        {
            btnReady.isHidden = false
        }
        
        
        if(statusID == "4")
            {
            btnDone.isHidden = false
        }
        
        
        cusNameLabel.text = cusname
        orderIdLabel.text = orderID
        statusLabel.text = status
        netAmountLabel.text = "Rs \(netAmount)"
        orderDetail.dataSource=self
        loadOrderDetails()
        
    }
    
    func alertMsg()
    {
        let alert = UIAlertController(title: "Success", message: "Status change success", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in 
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func readyBtn(_ sender: Any) {
        let orderRef = db.collection(K.fire.orderCollection).document(self.docID)

        
        orderRef.updateData([
            "status": "3",
            "statusName": "Ready"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.alertMsg()
                
                
            }
        }
    }
    @IBAction func doneBtn(_ sender: Any) {
        let orderRef = db.collection(K.fire.orderCollection).document(self.docID)

        
        orderRef.updateData([
            "status": "5",
            "statusName": "Done"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.alertMsg()
                
            }
        }
    }
    func loadOrderDetails()
    {
        orderDet = []
        
        db.collection("orderListDetail").whereField("orderID", isEqualTo: orderID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let foodName = data[K.orderList.foodName] as? String, let quantity = data[K.orderList.quantity] as? String, let uprice = data[K.orderList.uprice] as? String
                        {
                            
                            let newOrderDet = OrderItemInfo(foodName: foodName, quantity: quantity, unitPrice: uprice)
                            self.orderDet.append(newOrderDet)
                            
                            DispatchQueue.main.async {
                                self.orderDetail.reloadData()
                            }
                        }
                    }
                }
        }
    }
    


}

extension OrderDetailViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDet.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier4, for: indexPath) as! MyCustomCell4
        cell.foodNameLabel.text = orderDet[indexPath.row].foodName
        cell.quantityLabel.text = orderDet[indexPath.row].quantity
        cell.unitPriceLabel.text = "Rs \(orderDet[indexPath.row].unitPrice)"
        
        return cell
    }
    
    
}
