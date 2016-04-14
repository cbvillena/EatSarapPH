//
//  ConfirmOrderViewController.swift
//  EatSarap_PH
//
//  Created by userli on 04/04/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var identityText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        print(user?.customerid)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "finishOrder" {
            updateCustomer()
        }
    }
    
    func updateCustomer(){
        let json = ["customer_id": user!.customerid, "customer": ["customer_id": user!.customerid, "customer_identity": identityText.text!, "status": user!.customerstatus]] as Dictionary<String, AnyObject>
        
        
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            
            // create post request
            let url = NSURL(string: "http://172.20.2.174/eatsarapph/api/updateCustomer")!
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
