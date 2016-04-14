//
//  Item.swift
//  EatSarap_PH
//
//  Created by userli on 31/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class Order: NSObject, NSCoding {
    var orderid: Int
    var storeid: Int
    var customerid: Int
    var itemid: Int
    var quantity: Int

    
    struct PropertyKey {
        static let orderidKey = "orederid"
        static let storeidKey = "storeid"
        static let customeridKey = "customerid"
        static let itemidKey = "itemid"
        static let quantityKey = "quantity"
    }
    
    init?(orderid: Int, storeid: Int, customerid: Int, itemid: Int, quantity: Int){
        self.orderid = orderid
        self.storeid = storeid
        self.customerid = customerid
        self.itemid = itemid
        self.quantity = quantity
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(orderid, forKey: PropertyKey.orderidKey)
        aCoder.encodeObject(storeid, forKey: PropertyKey.storeidKey)
        aCoder.encodeObject(customerid, forKey: PropertyKey.customeridKey)
        aCoder.encodeObject(itemid, forKey: PropertyKey.itemidKey)
        aCoder.encodeObject(quantity, forKey: PropertyKey.quantityKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let orderid = aDecoder.decodeObjectForKey(PropertyKey.orderidKey) as! Int
        let storeid = aDecoder.decodeObjectForKey(PropertyKey.storeidKey) as! Int
        let customerid = aDecoder.decodeObjectForKey(PropertyKey.customeridKey) as! Int
        let itemid = aDecoder.decodeObjectForKey(PropertyKey.itemidKey) as! Int
        let quantity = aDecoder.decodeObjectForKey(PropertyKey.quantityKey) as! Int
        
        self.init(orderid: orderid, storeid: storeid, customerid: customerid, itemid: itemid, quantity: quantity)
    }
}
