//
//  Constants.swift
//  NIBM-FoodOrdering
//
//  Created by user189380 on 3/7/21.
//

struct K{
    
    static let registerSegue = "RegisterToFood"
    static let loginSegue = "LoginToFood"
    static let cellIdentifier = "ReusableCell"
    static let cellIdentifier2 = "ReusableCell2"
    static let cellIdentifier3 = "ReusableCell3"
    static let cellIdentifier4 = "ReusableCell4"
    
    struct fire
    {
        static let userCollection = "Users"
        static let foodColection = "FoodItems"
        static let categoryCollection = "categories"
        static let orderCollection = "orderList"
        static let statusCollection = "statusDet"
        static let catName = "name"
        static let foodName = "name"
        static let foodPrice = "price"
        static let foodDescription = "Description"
        static let foodCatID = "category"
        static let FoodCatType = "type"
        static let uid = "uid"
        
    }
    struct orderList
    {
        static let cusName = "cusName"
        static let orderID = "orderID"
        static let status = "status"
        static let foodName = "foodName"
        static let quantity = "quantity"
        static let uprice = "uPrice"
        static let statusName = "statusName"
        static let netAmount = "netAmount"
    }
    struct status
    {
        static let statusId = "statusId"
        static let statusName = "statusName"
    }
    
}
