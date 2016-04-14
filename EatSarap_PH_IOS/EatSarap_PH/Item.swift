//
//  Item.swift
//  EatSarap_PH
//
//  Created by userli on 31/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var itemid: Int
    var storeid: Int
    var itemname: String
    var price: Double
    var itemdescription: String
    var photourl: String
    var category: String
    
    struct PropertyKey {
        static let itemidKey = "itemid"
        static let storeidKey = "storeid"
        static let itemnameKey = "itemname"
        static let priceKey = "price"
        static let itemdescriptionKey = "itemdescription"
        static let photourlKey = "photourl"
        static let categoryKey = "category"
    }
    
    init?(itemid: Int, storeid: Int, itemname: String, price: Double, itemdescription: String, photourl: String, category: String){
        self.itemid = itemid
        self.storeid = storeid
        self.itemname = itemname
        self.price = price
        self.itemdescription = itemdescription
        self.photourl = photourl
        self.category = category
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(itemid, forKey: PropertyKey.itemidKey)
        aCoder.encodeObject(storeid, forKey: PropertyKey.storeidKey)
        aCoder.encodeObject(itemname, forKey: PropertyKey.itemnameKey)
        aCoder.encodeObject(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(itemdescription, forKey: PropertyKey.itemdescriptionKey)
        aCoder.encodeObject(photourl, forKey: PropertyKey.photourlKey)
        aCoder.encodeObject(category, forKey: PropertyKey.categoryKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let itemid = aDecoder.decodeObjectForKey(PropertyKey.itemidKey) as! Int
        let storeid = aDecoder.decodeObjectForKey(PropertyKey.storeidKey) as! Int
        let itemname = aDecoder.decodeObjectForKey(PropertyKey.itemnameKey) as! String
        let price = aDecoder.decodeObjectForKey(PropertyKey.priceKey) as! Double
        let itemdescription = aDecoder.decodeObjectForKey(PropertyKey.itemdescriptionKey) as! String
        let photourl = aDecoder.decodeObjectForKey(PropertyKey.photourlKey) as! String
        let category = aDecoder.decodeObjectForKey(PropertyKey.categoryKey) as! String
        
        self.init(itemid: itemid, storeid: storeid, itemname: itemname, price: price, itemdescription: itemdescription, photourl: photourl, category: category)
    }
}
