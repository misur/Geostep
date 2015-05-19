//
//  LoginViewController.swift
//  Geostep
//
//  Created by Wind on 16/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , NSXMLParserDelegate{
    
    
    var control =  Control()
    var settingsDAO = SettingsDAO()
    var userGameDAO = UserGameDAO()
    var gameDAO = GameDAO()
    var userDAO = UserDAO()
    
    
    
    var value: String = ""
    
    var parser = NSXMLParser()
    
    var posts = NSMutableArray()
    
    var games = NSMutableDictionary()
    
    var game =  NSString()
    
    var descrip = NSMutableString()
     var distance = NSMutableString()
     var gameNumber = NSMutableString()
     var isOutdoors = NSMutableString()
     var isTimeAttack = NSMutableString()
     var name = NSMutableString()
     var time = NSMutableString()
     var validFrom = NSMutableString()
     var validTo = NSMutableString()
    
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    @IBAction func OKPressed(sender: UIButton) {
        
        let password = PasswordTextField.text;
        let username = UsernameTextField.text;
        
        if(control.isConnectedToNetwork()){
            if(!username.isEmpty && !password.isEmpty ){
                
                let pom = password.md5()
                let pom2 = pom?.lowercaseString
                
            
                
               self.connectToServer(username, password: pom2! )

                
                
                return ;
                
            }else{
                displayMyAlertMessage("All fields are required");
                
                return ;
                
            }
            
            
        }else{
            displayMyAlertMessage("YOU DONT HAVE INTERNET CONNECTION");
        }
        
    }
    
    func connectToServer(username:String , password:String  ){
        
        
        
        var alert: UIAlertView = UIAlertView(title: "Connecting", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
        
        
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 67, 37)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        loadingIndicator.startAnimating()
        
        alert.show();
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://192.168.10.109:81/LogInScript.aspx?username=\(username)&password=\(password)")!)
        

        
        request.timeoutInterval =  10
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil {
                println("error=\(error)")
                alert.dismissWithClickedButtonIndex(-1, animated: true)
                self.displayMyAlertMessage("Bad connection")
                return
            }
            
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            
            self.myParserXML(data )
           
            
           
                        
            alert.dismissWithClickedButtonIndex(-1, animated: true)
            
            if(self.value == "bad_username"){
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.displayMyAlertMessage("bad username")
                    
                   
                }
                
            }else if(self.value == "bad_password"){
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                     self.displayMyAlertMessage("bad password")
                    
                   
                }
                
            }else if(self.value == "No games!" || self.posts.count > 0){
                dispatch_async(dispatch_get_main_queue()) {
                     self.saveDB(username ,password: password)
                    self.performSegueWithIdentifier("login", sender: self)
                }
                
            }
            
            
        })
        
        
    }
    
    
    func saveDB(username:String, password:String){
        
        
        if(settingsDAO.getLoggedUser() == ""){
             settingsDAO.saveToDB(username, language: "en", gameNumber: 0)
        }
        
        if(!userDAO.checkExistUser(username)){
            userDAO.saveToDB(username, password: password)
        }
       
       
        if(posts.count > 0 ){
            for post  in posts {
                
               
                    var pomDescript = post.valueForKey("description") as String
                    var pomDistance = post.valueForKey("distance") as String
                    var pomGameNumber = post.valueForKey("number") as String
                    var pomIsOutdoors = post.valueForKey("outdoors") as String
                    var pomIsTimeAttack = post.valueForKey("timeAttack") as String
                    var pomName = post.valueForKey("name") as String
                    var pomTime = post.valueForKey("time") as String
                    var pomValidFrom = post.valueForKey("validFrom") as String
                    var pomValidTo = post.valueForKey("validTo") as String
                    
                    if pomTime == "" {
                        pomTime = "0"
                    }
                    if pomDistance == "" {
                        pomDistance = "0"
                    }
                    
                    
                    let dou:Double = (pomDistance as NSString).doubleValue
                
                if(!gameDAO.checkExistGame(pomGameNumber.toInt()!)){
                    
                    gameDAO.saveToDB(pomDescript , distance:  dou , gameNumber: pomGameNumber.toInt()! , isOutdoors: pomIsOutdoors.toInt()! , isTimeAttack: pomIsTimeAttack.toInt()!, name: pomName, time: pomTime.toInt()! , validForm: pomValidFrom, validTo: pomValidTo)
                }
                
               
                let fkUserID = userDAO.getIdFor(username)
                let fkGameID = gameDAO.getIdFor(pomGameNumber.toInt()!)
                
                
               
                if( !userGameDAO.checkExistGame(fkUserID, gameID: fkGameID)){
                  
                    self.userGameDAO.saveToDB(0, activeClueNumber: 0, fkUserID: fkUserID, fkGameID: gameDAO.getIdFor(pomGameNumber.toInt()!))
                
                }
            }
        }
      
        
        
    }
    
    
    func myParserXML(data : NSData  ){
        self.parser = NSXMLParser(data: data )
        self.parser.delegate = self
        self.parser.shouldProcessNamespaces = false
        self.parser.shouldReportNamespacePrefixes = false
        self.parser.shouldResolveExternalEntities = false
        self.parser.parse()
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        game  = elementName
        
        if(elementName as NSString).isEqualToString("game"){
            games = NSMutableDictionary.alloc()
            games = [:]
            let attrs = attributeDict as [String: NSMutableString]
            
            if let prop = attrs["description"] {
                descrip = prop
            }
            let attrs1 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs1["distance"] {
                distance = prop
            }
            let attrs2 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs2["number"] {
                gameNumber = prop
            }
            
            let attrs3 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs3["name"] {
                name = prop
            }
            let attrs4 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs4["validFrom"] {
                validFrom = prop
            }
            let attrs5 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs5["validTo"] {
                validTo = prop
            }
            let attrs6 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs6["outdoors"] {
                isOutdoors = prop
            }
            let attrs7 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs7["timeAttack"] {
                isTimeAttack = prop
            }
            let attrs8 = attributeDict as [String: NSMutableString]
            
            if let prop = attrs8["time"] {
                time = prop
            }
            
        }
        
    }
    /*
    <games><game name="Wild hunt" number="721255" description="Divlja neka pretraga predivlja takoreci" validFrom="8/4/2014 3:26:36 PM" validTo="9/30/2014 3:26:36 PM" outdoors="1" timeAttack="1"/>
    */
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("game"){
            
            if !descrip.isEqual(nil ){
                games.setObject(descrip, forKey: "description")
            }
            if !distance.isEqual(nil ){
                games.setObject(distance, forKey: "distance")
            }
            if !gameNumber.isEqual(nil ){
                games.setObject(gameNumber, forKey: "number")
            }
            if !name.isEqual(nil ){
                games.setObject(name, forKey: "name")
            }
            if !validFrom.isEqual(nil ){
                games.setObject(validFrom, forKey: "validFrom")
            }
            if !validTo.isEqual(nil ){
                games.setObject(validTo, forKey: "validTo")
            }
            if !isOutdoors.isEqual(nil ){
               games.setObject(isOutdoors, forKey: "outdoors")
            }
            if !isTimeAttack.isEqual(nil ){
                games.setObject(isTimeAttack, forKey: "timeAttack")
            }
            if !time.isEqual(nil ){
                games.setObject(time, forKey: "time")
            }
            posts.addObject(games)
        }
        
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if(game.isEqualToString("games")){
            self.value = string
            
        }
        
        if game.isEqualToString("description") {
            descrip.appendString(string)
        } else if game.isEqualToString("distance") {
            distance.appendString(string)
        }else if game.isEqualToString("number") {
            gameNumber.appendString(string)
        }else if game.isEqualToString("name") {
            name.appendString(string)
        }else if game.isEqualToString("validFrom") {
            validFrom.appendString(string)
        }else if game.isEqualToString("validTo") {
            validTo.appendString(string)
        }else if game.isEqualToString("outdoors") {
            isOutdoors.appendString(string)
        }else if game.isEqualToString("timeAttack") {
            isTimeAttack.appendString(string)
        }else if game.isEqualToString("time") {
            time.appendString(string)
        }
        
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        
    }
    
    
    
    
    func displayMyAlertMessage( userMessage:String){
        
        var myAlert =  UIAlertController(title: "Alert" , message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
        
        
        
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
