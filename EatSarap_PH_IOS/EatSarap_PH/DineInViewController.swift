//
//  DineInViewController.swift
//  EatSarap_PH
//
//  Created by userli on 29/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class DineInViewController: UIViewController {

    var store: Store?
    var user: User?
    
    @IBOutlet weak var idtextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backToHome(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromInputDT" {
            let storeDetailViewController = segue.destinationViewController as! StoreDetailsViewController
            storeDetailViewController.user = createUser()
            storeDetailViewController.store = parseJSON()
        }
    }
    
    func parseJSON() -> Store{
        
        do {
            let id = idtextField.text!
            let data = NSData(contentsOfURL: NSURL(string: "http://172.20.2.174/eatsarapph/api/getStoreDetails?store_id=\(id)")!)
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]
            //print((jsonResult!["store_id"])!)
            let storeid = (jsonResult!["store_id"])! as! String
            let telno = (jsonResult!["phonenumber"])! as! String
            let servicecharge = (jsonResult!["servicecharge"])! as! String
            //print(storeid)
            store = Store(storeid: Int(storeid)!, storename: (jsonResult!["storename"])! as! String, storeaddress: (jsonResult!["storeaddress"])! as! String, phonenumber: Int(telno)!, emailaddress: (jsonResult!["emailaddress"])! as! String, coverphoto: (jsonResult!["storephoto_url"])! as! String, servicecharge: Int(servicecharge)!)!
            //print(servicecharge)
            
        } catch let error as NSError {
            print(error)
        }
        return store!
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
