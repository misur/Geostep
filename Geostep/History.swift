//
//  History.swift
//  Geostep
//
//  Created by Wind on 24/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CryptoSwift


class History: UIViewController,UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    var game = GameDAO()
    var settingsDAO  = SettingsDAO()
    var userGameDAO = UserGameDAO()
    
    var userDAO = UserDAO()

    var swiftBlogs = [String]()
    
    var data = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loggedUser = settingsDAO.getLoggedUser()
        let id =  userDAO.getIdFor(loggedUser)
        let arr:Array<String>  = userGameDAO.getAllIDForGame(id)
        for  item in arr {
        
            swiftBlogs.append(game.getNameByID(item))
        
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "historyInfo") {
            var svc = segue.destinationViewController as HistoryInfo;
            
            svc.toPass = data
            
        }
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        data =  swiftBlogs[row]
        self.performSegueWithIdentifier("historyInfo", sender: self)
        
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
