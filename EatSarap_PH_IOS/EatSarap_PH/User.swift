//
//  User.swift
//  EatSarap_PH
//
//  Created by userli on 01/04/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var customerid: Int
    var customeridentity: String
    var customerstatus: Int
    
    struct PropertyKey {
        static let idKey = "customerid"
        static let identityKey = "customeridentity"
        static let statusKey = "customerstatus"
    }
    
    init?(customerid: Int, customeridentity: String, customerstatus: Int) {
        self.customerid = customerid
        self.customeridentity = customeridentity
        self.customerstatus = customerstatus
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(customerid, forKey: PropertyKey.idKey)
        aCoder.encodeObject(customeridentity, forKey: PropertyKey.identityKey)
        aCoder.encodeObject(customerstatus, forKey: PropertyKey.statusKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let customerid = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! Int
        let customeridentity = aDecoder.decodeObjectForKey(PropertyKey.identityKey) as! String
        let customerstatus = aDecoder.decodeObjectForKey(PropertyKey.statusKey) as! Int
        
        self.init(customerid: customerid, customeridentity: customeridentity, customerstatus: customerstatus)
    }
}
