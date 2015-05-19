//
//  ViewController.swift
//  Geostep
//
//  Created by Wind on 16/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var settingsDAO = SettingsDAO()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if(settingsDAO.getLoggedUser() != ""){
        
         self.performSegueWithIdentifier("stepLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

