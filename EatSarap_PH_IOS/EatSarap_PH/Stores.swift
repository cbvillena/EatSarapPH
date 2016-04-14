//
//  Stores.swift
//  EatSarap_PH
//
//  Created by userli on 30/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class Stores {
    var storeid: String?
    var storename: String?
    var storeaddress: String?
    var phonenumber: String?
    var emailaddress: String?
    var coverphoto: String?
    var servicecharge: String?
    
    init(json: NSDictionary){
        self.storeid = json["store_id"] as? String
        self.storename = json["storename"] as? String
        self.storeaddress = json["storeaddress"] as? String
        self.phonenumber = json["phonenumber"] as? String
        self.emailaddress = json["emailaddress"] as? String
        self.coverphoto = json["storephoto_url"] as? String
        self.servicecharge = json["servicecharge"] as? String
    }
}
