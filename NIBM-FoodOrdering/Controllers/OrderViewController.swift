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
    
    var acceptTap: (() -> Void)? = nil
    var rejectTap: (() -> Void)? = nil
    @IBAction func aceeptBtn(_ sender: Any) {
        acceptTap?()
    }
    
    @IBAction func rejectBtn(_ sender: Any) {
        rejectTap?()
    }
    
}

class OrderViewController: UIViewController {

    let db = Firestore.firestore()
    var orders: [Orders] = []
    var status: [Status] = []
    
    
    @IBOutlet weak var orderTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        orderTableView.dataSource=self
        orderTableView.delegate=self
        loadStatus()
        loadOrders()
        
    }

    func loadStatus()
    {
        status = []
        
        db.collection(K.fire.statusCollection).getDocuments(){(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let statusId = data[K.status.statusId] as? String, let statusName = data[K.status.statusName] as? String
                        {
                            
                            let newstatus = Status(statusID: statusId, statusName: statusName)
                            self.status.append(newstatus)
                            
                            DispatchQueue.main.async {
                                
                                self.orderTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }

    }
    
    func loadOrders(){
        
        orders = []
        db.collection(K.fire.orderCollection).addSnapshotListener(){(querySnapshot,error) in
            if let e=error
            {
                print("failed to load data \(e)")
            }
            else{
                self.orders.removeAll()
                if let snapshotDocument = querySnapshot?.documents{
                    for doc in snapshotDocument{
                        let data = doc.data()
                        if let cusName = data[K.orderList.cusName] as? String, let orderID = data[K.orderList.orderID] as? String, let status = data[K.orderList.status] as? String, let statusName = data[K.orderList.statusName] as? String, let netAmount = data[K.orderList.netAmount] as? String, let docId = doc.documentID as? String
                        {
                            
                            let newOrder = Orders(cusName: cusName, status: status, orderID: orderID, statusName: statusName,netAmount: netAmount,docId:docId)
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

    func approveOrder(docId:String)
    {
        let orderRef = db.collection(K.fire.orderCollection).document(docId)

        
        orderRef.updateData([
            "status": "2",
            "statusName": "Preparation"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func rejectOrder(docId:String)
    {
        let orderRef = db.collection(K.fire.orderCollection).document(docId)

        
        orderRef.updateData([
            "status": "6",
            "statusName": "Cancel"
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }

}

extension OrderViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return status.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var filterArr: [Orders] = []
        filterArr = orders.filter{($0.status.contains(status[section].statusID))}
        return filterArr.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier3, for: indexPath) as! MyCustomCell3
        var filterArr: [Orders] = []
        filterArr = orders.filter{($0.status.contains(status[indexPath.section].statusID))}
       
        cell.cusNameLabel.text = filterArr[indexPath.row].cusName
        cell.orderIdLabel.text = filterArr[indexPath.row].orderID
        cell.btnStatus.setTitle(filterArr[indexPath.row].statusName, for: .normal
        )
        cell.btnAdd.isHidden=true
        cell.btnReject.isHidden=true
        if filterArr[indexPath.row].status == "1"
        {
            cell.btnAdd.isHidden=false
            cell.btnReject.isHidden=false
        }
        
        cell.acceptTap = {
            self.approveOrder(docId: filterArr[indexPath.row].docId)
            self.orderTableView.reloadData()
        }
        cell.rejectTap = {
            self.rejectOrder(docId: filterArr[indexPath.row].docId)
            self.orderTableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return status[section].statusName
      }
    
    
}

extension OrderViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  next = (storyboard?.instantiateViewController(identifier: "OrderDetailViewController") as! OrderDetailViewController)

        self.navigationController?.pushViewController(next, animated: true)
        var filterArr: [Orders] = []
        filterArr = orders.filter{($0.status.contains(status[indexPath.section].statusID))}
        let order = filterArr[indexPath.row]
        
        next.cusname=order.cusName
        next.orderID=order.orderID
        next.status=order.statusName
        next.netAmount=order.netAmount
        next.statusID=order.status
        next.docID=order.docId
    }
    
}
