//
//  UserDAO.swift
//  Geostep
//
//  Created by Wind on 20/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class UserDAO {
    
    
    func saveToDB ( username:String , password :String){
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext =  appDel.managedObjectContext!
        
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("User_table", inManagedObjectContext: context) as NSManagedObject
        
        var  id = getMaxId() + 1
        
        newUser.setValue(id , forKey: "id")
        
        newUser.setValue(username, forKey: "username")
        
        let pomPass = "\(password.md5())"
        
        newUser.setValue( pomPass.lowercaseString , forKey: "password")
        
        
        context.save(nil )
        println("You are create account")
        
    }
    
    
    func getMaxId()-> Int{
        
        var arrID:Array<Int> = []
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table");
        
        request.returnsObjectsAsFaults = false ;
        
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                let pomId = pom.valueForKey("id") as Int
                arrID.append(pomId)
                
            }
        }
        let numMax = arrID.reduce(Int.min, { max($0, $1) })
        return numMax
        
    }
    
    
    func checkExistUser(username:String) -> Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table");
        
        request.returnsObjectsAsFaults = false ;
        
        request.predicate = NSPredicate(format: "username = %@", username)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        
        if(results.count  == 1){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                
                let pomUsername = pom.valueForKey("username") as String
                
                
                return  true
                
            }
        }else{
            println("Settings  is empty")
            return false
        }
        return false
        
    }
    
    
    
    
    func getIdFor(username: String)->String {
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table");
        
        request.returnsObjectsAsFaults = false ;
        
        // make query
        
        request.predicate = NSPredicate(format: "username = %@", username)
        //
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count == 1){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                let s:Int  = pom.valueForKey("id")as Int
                return "\(s)"
                
            }
        }
        return ""
        
    }
    
    func deleteFromDB(){
        
        var MyList: Array<AnyObject>   = []
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "User_table")
        MyList = context.executeFetchRequest(request, error: nil)!
        var bas: AnyObject!
        
        
        for bas: AnyObject in MyList
        {
            context.deleteObject(bas as NSManagedObject)
        }
        
        context.save(nil )
        
        
        
        
        println("Delete all from user table ")
    }
    

    func getFromDB(){
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table");
        
        request.returnsObjectsAsFaults = false ;
        
      
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                println(pom)
              
                
            }
        }
    }
    
  
    
    
    
    
}
