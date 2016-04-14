//
//  StoreListViewController.swift
//  EatSarap_PH
//
//  Created by userli on 30/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class StoreListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var storesTbl: UITableView!
    
    var stores = [Stores]()
    var store: Store?
    var user: User?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let store = stores[indexPath.row]
        
        cell.textLabel?.text = store.storename
        cell.detailTextLabel?.text = store.storeaddress
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(){
        do {
            let data = NSData(contentsOfURL: NSURL(string: "http://172.20.2.174/eatsarapph/api/storeList")!)
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
            //print(jsonResult)
            
            for store in jsonResult as! [Dictionary<String, AnyObject>]{
                stores.append(Stores(json: store))
            }
        } catch let error as NSError {
            print(error)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStoreDetails" {
            let storeDetailViewController = segue.destinationViewController as! StoreDetailsViewController
            
            if let selectedStoreCell = sender as? UITableViewCell {
                let indexPath = storesTbl.indexPathForCell(selectedStoreCell)!
                let selectedStore = stores[indexPath.row]
                print(selectedStore.storeid)
                let selectedStoreObject = Store(storeid: Int(selectedStore.storeid!)!, storename: selectedStore.storename!, storeaddress: selectedStore.storeaddress!, phonenumber: Int(selectedStore.phonenumber!)!, emailaddress: selectedStore.emailaddress!, coverphoto: selectedStore.coverphoto!, servicecharge: Int(selectedStore.servicecharge!)!)
                //print(selectedStore.storeid)
                storeDetailViewController.store = selectedStoreObject
                storeDetailViewController.user = createUser()
            }
            
            
        }
    }
    
    func createUser() -> User {
        if let newUser = user {
            print(newUser)
        } else {
            insertUser()
            print(user?.customerid)
        }
        
        return user!
    }
    
    func insertUser(){
        let id = generateId(5)
        print(id)
        
        let json = ["customer_id": id, "customer_identity": "", "status": 1] as Dictionary<String, AnyObject>
        
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            //let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(jsonData)
            //print(dataExample)
            //let dictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(dataExample)! as! NSDictionary
            //print(jsonData)
            
            // create post request
            let url = NSURL(string: "http://172.20.2.174/eatsarapph/api/addCustomer")!
            
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
            
            user = User(customerid: id, customeridentity: "", customerstatus: 1)
            
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
