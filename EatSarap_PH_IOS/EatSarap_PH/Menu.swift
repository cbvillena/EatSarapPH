//
//  Menu.swift
//  EatSarap_PH
//
//  Created by userli on 31/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class Menu {
    var itemid: String?
    var storeid: String?
    var itemname: String?
    var price: String?
    var description: String?
    var photourl: String?
    var category: String?
    
    init(json: NSDictionary){
        self.itemid = json["item_id"] as? String
        self.storeid = json["store_id"] as? String
        self.itemname = json["item_name"] as? String
        self.price = json["price"] as? String
        self.description = json["description"] as? String
        self.photourl = json["itemphoto_url"] as? String
        self.category = json["category_name"] as? String
    }
}

