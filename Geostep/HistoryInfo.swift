//
//  HistoryInfo.swift
//  Geostep
//
//  Created by Wind on 05/05/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class HistoryInfo: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var toPass:String!
    
    var gameDAO = GameDAO()
    
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var outdoorsLabel: UILabel!
    
    
    
    @IBOutlet weak var timeAttackLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = toPass
        let pom = gameDAO.getInfoByName(toPass)
        
        descriptionLabel.text = pom.descript
        if(pom.outdoors == "1"){
            outdoorsLabel.text = "Outdoors"
        }else if (pom.outdoors == "0" ) {
            outdoorsLabel.text = "Indoors"
        }
        if(pom.isTimeAttack == "1"){
            timeAttackLabel.text = "Time attack"
        }else if(pom.isTimeAttack == "0"){
            timeAttackLabel.text  = "Regular game"
        }
        
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
