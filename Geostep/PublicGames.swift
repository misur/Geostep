//
//  PublicGames.swift
//  Geostep
//
//  Created by Wind on 08/05/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class PublicGames: UIViewController {

    
    @IBOutlet weak var TestB: UIButton!
    
    
    @IBAction func Back(sender: UIBarButtonItem) {
        
        
        let view2 = self.storyboard?.instantiateViewControllerWithIdentifier("toMain") as Main
        
        self.navigationController?.pushViewController(view2, animated: true)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        TestB.addTarget(self.revealViewController(), action: Selector("revealToggle:"), forControlEvents: UIControlEvents.TouchUpInside)
        //slide menu
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
