//
//  Store.swift
//  EatSarap_PH
//
//  Created by userli on 30/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class Store: NSObject, NSCoding {
    var storeid: Int
    var storename: String
    var storeaddress: String
    var phonenumber: Int
    var emailaddress: String
    var coverphoto: String
    var servicecharge: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("stores")
    
    struct PropertyKey {
        static let storeidKey = "storeid"
        static let storenameKey = "storename"
        static let storeaddressKey = "storeaddress"
        static let phonenumberKey = "phonenumber"
        static let emailaddressKey = "emailaddress"
        static let coverphotoKey = "coverphoto"
        static let servicechargeKey = "servicecharge"
    }
    
    init?(storeid: Int, storename: String, storeaddress: String,phonenumber: Int, emailaddress: String, coverphoto: String,servicecharge: Int) {
        self.storeid = storeid
        self.storename = storename
        self.storeaddress = storeaddress
        self.phonenumber = phonenumber
        self.emailaddress = emailaddress
        self.coverphoto = coverphoto
        self.servicecharge = servicecharge
        
        super.init()
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(storeid, forKey: PropertyKey.storeidKey)
        aCoder.encodeObject(storename, forKey: PropertyKey.storenameKey)
        aCoder.encodeObject(storeaddress, forKey: PropertyKey.storeaddressKey)
        aCoder.encodeObject(phonenumber, forKey: PropertyKey.phonenumberKey)
        aCoder.encodeObject(emailaddress, forKey: PropertyKey.emailaddressKey)
        aCoder.encodeObject(coverphoto, forKey: PropertyKey.coverphotoKey)
        aCoder.encodeObject(servicecharge, forKey: PropertyKey.servicechargeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storeid = aDecoder.decodeObjectForKey(PropertyKey.storeidKey) as! Int
        let storename = aDecoder.decodeObjectForKey(PropertyKey.storenameKey) as! String
        let storeaddress = aDecoder.decodeObjectForKey(PropertyKey.storeaddressKey)as! String
        let phonenumber = aDecoder.decodeObjectForKey(PropertyKey.phonenumberKey) as! Int
        let emailaddress = aDecoder.decodeObjectForKey(PropertyKey.emailaddressKey) as! String
        let coverphoto = aDecoder.decodeObjectForKey(PropertyKey.coverphotoKey) as! String
        let servicecharge = aDecoder.decodeObjectForKey(PropertyKey.servicechargeKey) as! Int
        
        self.init(storeid: storeid, storename: storename, storeaddress: storeaddress, phonenumber: phonenumber, emailaddress: emailaddress, coverphoto: coverphoto, servicecharge: servicecharge)
    }
}
