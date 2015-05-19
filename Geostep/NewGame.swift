//
//  NewGame.swift
//  Geostep
//
//  Created by Wind on 04/05/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class NewGame: UIViewController {
    
    
    
    @IBOutlet weak var gameNumber: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PressedOK(sender: UIButton) {
        if(gameNumber.text == ""){
            displayMyAlertMessage("You have to enter game number")
        }
        
    }
    
    func displayMyAlertMessage( userMessage:String){
        
        var myAlert =  UIAlertController(title: "Alert" , message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
        
        
        
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
