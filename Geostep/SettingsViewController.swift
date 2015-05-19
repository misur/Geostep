//
//  SettingsViewController.swift
//  Geostep
//
//  Created by Wind on 16/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var settingsDAO = SettingsDAO()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func LogoutPressed(sender: UIButton) {
        settingsDAO.deleteFromDB()
        self.performSegueWithIdentifier("logout", sender: self)
    }

}
