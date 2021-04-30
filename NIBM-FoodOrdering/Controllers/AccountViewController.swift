//
//  AccountViewController.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

import UIKit
import Firebase
import Foundation

class MyCustomCell5: UITableViewCell{
    
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var cusNameLabel: UILabel!
    @IBOutlet weak var netAmountLabel: UILabel!
}
class AccountViewController: UIViewController {
    let db = Firestore.firestore()
    var orders: [Orders] = []
    
    @IBOutlet weak var orderHistoryTableView: UITableView!
    @IBOutlet weak var toDatePicker: UIDatePicker!
    @IBOutlet weak var fromDatePicker: UIDatePicker!
    
    @IBAction func searchBtn(_ sender: Any) {
        print("temp \(toDatePicker.date)")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YY, MMM d, hh:mm"
//        let tostring = dateFormatter.string(from: toDatePicker.date)
//        let fromstring = dateFormatter.string(from: fromDatePicker.date)
//
//        let to = dateFormatter.date(from: tostring)
//        let from = dateFormatter.date(from: fromstring)
        loadOrderHistory(toDate: toDatePicker.date, fromDate: fromDatePicker.date)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        orderHistoryTableView.dataSource=self
        
    }
    

    @IBAction func printBtn(_ sender: Any) {
        let pdfFilePath = self.orderHistoryTableView.exportAsPdfFromTable()
        let alert = UIAlertController(title: "Your File path", message: pdfFilePath, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil ))
        self.present(alert, animated: true, completion: nil)
//        print(pdfFilePath)
    }
    @IBAction func LogoutBtn(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
    func loadOrderHistory(toDate:Date,fromDate:Date)
    {
        orders=[]

        db.collection(K.fire.orderCollection).whereField("date", isGreaterThan: fromDate).whereField("date", isLessThan: toDate)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let cusName = data[K.orderList.cusName] as? String, let orderID = data[K.orderList.orderID] as? String, let status = data[K.orderList.status] as? String, let statusName = data[K.orderList.statusName] as? String, let netAmount = data[K.orderList.netAmount] as? String, let docId = document.documentID as? String
                        {
                            
                            let newOrder = Orders(cusName: cusName, status: status, orderID: orderID, statusName: statusName,netAmount: netAmount,docId:docId)
                            self.orders.append(newOrder)
                            print(self.orders)
                            DispatchQueue.main.async {
                                self.orderHistoryTableView.reloadData()
                            }
                        }
                    }
                }
        }

    }

}


extension AccountViewController:UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier5, for: indexPath) as! MyCustomCell5
        cell.cusNameLabel.text = orders[indexPath.row].cusName
        cell.orderIDLabel.text = orders[indexPath.row].orderID
        cell.netAmountLabel.text = "Rs \(orders[indexPath.row].netAmount)"
        
        return cell
    }
    
    
}
extension UITableView {
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    func exportAsPdfFromTable() -> String {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        self.bounds = originalBounds
        // Save pdf data
        return self.saveTablePdf(data: pdfData)
        
    }
    
    // Save pdf file in document directory
    func saveTablePdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("tablePdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
