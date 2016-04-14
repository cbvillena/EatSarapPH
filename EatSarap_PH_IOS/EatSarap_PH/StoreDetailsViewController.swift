//
//  StoreDetailsViewController.swift
//  EatSarap_PH
//
//  Created by userli on 30/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class StoreDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var store: Store?
    var user: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = store?.storename
        idLabel.text = String(store!.storeid)
        addressLabel.text = store?.storeaddress
        phoneLabel.text = String(store!.phonenumber)
        emailLabel.text = store?.emailaddress
        load_image("http://172.20.2.174/eatsarapph/\(store!.coverphoto)")
        

        // Do any additional setup after loading the view.
    }
    
    func load_image(urlString:String)
    {
        //print(urlString)
        // Create Url from string
        let url = NSURL(string: urlString)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imgView.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "placeorder" {
            let menuListViewController = segue.destinationViewController as! MenuViewController
            //print(store?.storeid)
            menuListViewController.store = store
            menuListViewController.user = user
            
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
