//
//  MenuViewController.swift
//  EatSarap_PH
//
//  Created by userli on 31/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource {

    var menu = [Menu]()
    var item: Item?
    var store: Store?
    var user: User?
    var order: Order?
    var orders = [String]()
    
    @IBOutlet weak var servicecharge: UILabel!
    @IBOutlet weak var totalBill: UILabel!
    @IBOutlet weak var menuTbl: UITableView!
    
    var totalAmount: Double = 0.00
    //var chargedAmount: Double = 0.00
    
    var orderArray =  [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "\((store?.storeid)!) Menu"
        parseJSON()        
        totalBill.text = String(format: "%.2f", totalAmount)
        servicecharge.text = "\(store!.servicecharge)%"
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuCell"
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ItemTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? ItemTableViewCell
        
        let menuItem = menu[indexPath.row]
        
            //cell!.hiddenQuantity.text = String(indexPath.row)
            
            //cell = ItemTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            cell!.itemNameLbl.text = menuItem.itemname
            cell!.itemDescLbl.text = menuItem.description
            cell!.itemPriceLbl.text = String(format: "%.2f", Double(menuItem.price!)!)
            cell!.addBtn.setTitle("Add", forState: .Normal)
            cell!.quantityTxt.text = String(0)
            cell!.quantityTxt.enabled = true
        
        if (orders.contains(menuItem.itemid!) == true) {
            cell!.addBtn.setTitle("Reset", forState: .Normal)
            cell!.quantityTxt.text = cell!.hiddenQuantity.text
            cell!.quantityTxt.enabled = false
        }
        
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            cell!.addBtn.tag = indexPath.row
                //print(cell.addBtn.tag)
            cell!.addBtn.addTarget(self, action: "addItem:", forControlEvents: .TouchUpInside)
        })
        
        let url = NSURL(string: "http://172.20.2.174/eatsarapph/\(menuItem.photourl!)")!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    //if let originalCell = tableView.cellForRowAtIndexPath(indexPath) {
                        cell!.imgView!.image = UIImage(data: data)
                        //cell.imgView!.frame = CGRectMake(5,5,35,35)
                    //}
                })
            }
        }

        task.resume()
        
        return cell!
        
    }
    
    func addItem(sender: UIButton){
        if sender.titleLabel?.text == "Add" {
            //let button = sender
            //let view = button.superview!
            
            //let cell = view.superview as! ItemTableViewCell
            let touchPoint: CGPoint = sender.convertPoint(CGPointZero, toView: menuTbl)
            // maintable --> replace your tableview name
            let indexPath: NSIndexPath = menuTbl.indexPathForRowAtPoint(touchPoint)!
            
            let cell = menuTbl.cellForRowAtIndexPath(indexPath) as! ItemTableViewCell
            //let indexPath = menuTbl.indexPathForCell(cell)
            
            //print(indexPath?.row)
            let itemmenu = menu[indexPath.row]
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if (cell.quantityTxt.text != "") {
                let itemAmount: Double = Double(cell.quantityTxt.text!)! * Double(itemmenu.price!)!
                self.totalAmount = self.totalAmount + itemAmount
                let charge = self.totalAmount * Double(self.store!.servicecharge)/100
                //chargedAmount = totalAmount + charge
                self.totalBill.text = String(format: "%.2f", self.totalAmount + charge)
                cell.quantityTxt.enabled = false
                cell.hiddenQuantity.text = cell.quantityTxt.text
                self.orders.append(itemmenu.itemid!)
                
                let orderid = "\(String(self.user!.customerid))\(String(itemmenu.itemid!))"
                self.order = Order(orderid: Int(orderid)!, storeid: self.store!.storeid, customerid: self.user!.customerid, itemid: Int(itemmenu.itemid!)!, quantity: Int(cell.quantityTxt.text!)!)
                //print(order)
                self.orderArray.append(self.order!)
                sender.setTitle("Reset", forState: .Normal)
            } else {
                self.totalAmount = self.totalAmount + 0
                self.totalBill.text = String(format: "%.2f", self.totalAmount)
            }
            })
            
        }
        else {
            let button = sender
            let view = button.superview!
            let cell = view.superview as! ItemTableViewCell
            
            let indexPath = menuTbl.indexPathForCell(cell)
            let itemmenu = menu[indexPath!.row]
            
            let itemAmount: Double = Double(cell.quantityTxt.text!)! * Double(itemmenu.price!)!
            //totalAmount = totalAmount - charge
            totalAmount = totalAmount - itemAmount
            let charge = totalAmount * Double(store!.servicecharge)/100
            //chargedAmount = totalAmount - charge
            totalBill.text = String(format: "%.2f", totalAmount + charge)
            cell.quantityTxt.enabled = true
            cell.quantityTxt.text = ""
            for(var a = 0; a < orders.count; a++){
                if (orders[a] == itemmenu.itemid){
                    orders.removeAtIndex(a)
                }
            }
            
            for(var i = 0; i < orderArray.count; i++){
                if (orderArray[i].itemid == Int(itemmenu.itemid!)) {
                    orderArray.removeAtIndex(i)
                }
            }
            print(orderArray)

            sender.setTitle("Add", forState: .Normal)
        }
        
    }
    
    func parseJSON(){
        do {
            //print((store?.storeid)!)
            
            let id = (store?.storeid)!
            
            let data = NSData(contentsOfURL: NSURL(string: "http://172.20.2.174/eatsarapph/api/getStoreMenu?store_id=\(id)")!)
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            //print(jsonResult)
            
            for item in jsonResult as! [Dictionary<String, AnyObject>]{
                menu.append(Menu(json: item))
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showItem" {
            let itemViewController = segue.destinationViewController as! ItemViewController
            
            if let selectedItemCell = sender as? ItemTableViewCell {
                let indexPath = menuTbl.indexPathForCell(selectedItemCell)!
                let selectedItem = menu[indexPath.row]
                let selectedItemObject = Item(itemid: Int(selectedItem.itemid!)!, storeid: Int((store?.storeid)!), itemname: selectedItem.itemname!, price: Double(selectedItem.price!)!, itemdescription: selectedItem.description!, photourl: selectedItem.photourl!, category: selectedItem.category!)
                
                itemViewController.item = selectedItemObject
                itemViewController.store = store
                itemViewController.user = user
            }
            
        }
        else if segue.identifier == "confirmOrder" {
            for(var a = 0; a < orderArray.count; a++){
                insertOrder(orderArray[a])
            }
            let confirmOrderController = segue.destinationViewController as! ConfirmOrderViewController
            confirmOrderController.user = user
        }
    }
    
    func insertOrder(order: Order){

        let json = ["order_id": order.orderid, "store_id": order.storeid, "customer_id": order.customerid, "item_id": order.itemid, "quantity": order.quantity] as Dictionary<String, AnyObject>
        
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            
            // create post request
            let url = NSURL(string: "http://172.20.2.174/eatsarapph/api/addOrder")!
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            
            
            // insert json data to request
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) -> Void in
                if error != nil{
                    print("Error -> \(error)")
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: '\(jsonStr)'")
                    return
                }
                
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    
                    //let userId = result!["data"]!["customer_id"] as! Int
                    print("Result -> \(result)")
                    
                } catch {
                    print("Error -> \(error)")
                }
                
            }
            
            //user = User(customerid: id, customeridentity: "", customerstatus: 1)
            
            task.resume()
            //return task
            
        } catch {
            print(error)
        }
    }
    
    func generateId(numDigits: Int) -> Int{
        var place: Int = 1
        var finalNumber: Int = 0;
        for(var i: Int = 0; i < numDigits; i++){
            place = place * 10
            let randomNumber: Int = Int(arc4random_uniform(10))
            finalNumber += randomNumber * place
        }
        return finalNumber
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
