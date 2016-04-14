//
//  ItemViewController.swift
//  EatSarap_PH
//
//  Created by userli on 31/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemcategory: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    var store: Store?
    var user: User?
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(item?.photourl)
        load_image("http://172.20.2.174/eatsarapph/\(item!.photourl)")

        // Do any additional setup after loading the view.
    }
    
    func load_image(urlString:String)
    {
        itemcategory.text = item?.category
        itemTitle.text = item?.itemname
        itemDesc.text = item?.itemdescription
        itemPrice.text = String(format: "%.2f", (item?.price)!)
        
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
    
    @IBAction func backToMenu(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToMenuList" {
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
