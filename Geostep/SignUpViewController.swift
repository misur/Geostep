//
//  SignUpViewController.swift
//  Geostep
//
//  Created by Wind on 16/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CryptoSwift

class SignUpViewController: UIViewController, NSXMLParserDelegate {
    
 
    @IBOutlet weak var EmailTextField: UITextField!
    
    
   
    @IBOutlet weak var UsernameTextField: UITextField!
    
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    
    var parser = NSXMLParser()
    var elements = NSMutableDictionary()
    var element =  NSString()
    var value: String = ""
    
    var control  =  Control()
    
    var settingsDAO = SettingsDAO()
    var userDAO = UserDAO()

    
 
    @IBAction func OKPressed(sender: UIButton) {
        
        let email = EmailTextField.text;
        let password = PasswordTextField.text;
        let username = UsernameTextField.text;
        
        
        
        if(control.isConnectedToNetwork()){
            
            if(!email.isEmpty && !username.isEmpty && !password.isEmpty ){
                
                if(control.isValidEmail(email)){
                    
                    
                    let pom = password.md5()
                    let pom2 = pom?.lowercaseString
                    
                    saveToServer( username ,email: email  ,password: pom2!);
                    
                    
                }else{
                    displayMyAlertMessage("Your email is not correct")
                    return ;
                }
                
                
            }else{
                displayMyAlertMessage("All fields are required");
                
                return ;
                
            }
            
        }else{
            displayMyAlertMessage("YOU DONT HAVE INTERNET CONNECTION");
        }
    }
    
    
    func saveToDB(name:String , email:String , password:String){
        
        if(settingsDAO.getLoggedUser() == ""){
            settingsDAO.saveToDB(name, language: "en", gameNumber: 0)
        }
        
        if(!userDAO.checkExistUser(name)){
            userDAO.saveToDB(name, password: password)
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
    

    
    func saveToServer(name:String , email:String , password:String){
        
        
        
        var alert: UIAlertView = UIAlertView(title: "Connecting", message: "Please wait...", delegate: nil, cancelButtonTitle: nil);
        
        
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 67, 37)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        loadingIndicator.startAnimating()
        
        alert.show();
        
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://192.168.10.109:81/SingUpScript.aspx?username=\(name)&password=\(password)&email=\(email)")!)
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
            
            if(self.value == "username_exists"){
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.displayMyAlertMessage("Username exist ")
                 
                }
                
                
                
            }else if(self.value == "email_exists"){
                
                dispatch_async(dispatch_get_main_queue()) {
                     self.displayMyAlertMessage("Email  exist ")
                  
                }
                
                
                
            }
            
            if(self.value == "success"){
                dispatch_async(dispatch_get_main_queue()) {
                    self.saveToDB(name, email: email, password: password)
                    self.performSegueWithIdentifier("create", sender: self)
                }
            }
            
        })
        
    }
    
    

    
    
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        
        element = elementName
        
        if(element as NSString).isEqualToString("result"){
            elements = NSMutableDictionary.alloc()
            elements = [:]
            
            
        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("result"){
            
        }
        
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if(element.isEqualToString("result")){
            self.value = string
            
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
