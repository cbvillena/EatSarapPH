//
//  HomeViewController.swift
//  EatSarap_PH
//
//  Created by userli on 29/03/2016.
//  Copyright © 2016 ITDC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dineinBtn: UIButton!
    @IBOutlet weak var deliveryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureButton()
    {
        dineinBtn.layer.cornerRadius = 0.5 * dineinBtn.bounds.size.width
        dineinBtn.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1).CGColor as CGColorRef
        dineinBtn.layer.borderWidth = 2.0
        dineinBtn.clipsToBounds = true
        
        deliveryBtn.layer.cornerRadius = 0.5 * deliveryBtn.bounds.size.width
        deliveryBtn.layer.borderColor = UIColor(red:255.0/255.0, green:255.0/255.0, blue:255.0/255.0, alpha:1).CGColor as CGColorRef
        deliveryBtn.layer.borderWidth = 2.0
        deliveryBtn.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        configureButton()
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
