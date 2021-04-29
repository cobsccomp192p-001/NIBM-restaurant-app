//
//  OrderList.swift
//  NIBM-FoodOrdering
//
//  Created by user189391 on 4/29/21.
//

import Foundation

class OrderList {
    
    var foodName:String
    var quantity:String
    var unitPrice:String
    var orderId:String
    
    init(foodName:String,quantity:String,unitPrice:String,orderId:String) {
        self.foodName = foodName
        self.orderId = orderId
        self.quantity = quantity
        self.unitPrice = unitPrice
        
    }
}
