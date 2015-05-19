//
//  SettingsDAO.swift
//  Geostep
//
//  Created by Wind on 17/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//
import UIKit
import Foundation
import CoreData

public class SettingsDAO {
    
   
    
    
    
    
     func saveToDB ( username:String , language :String , gameNumber:Int){
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext =  appDel.managedObjectContext!
        
        
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: context) as NSManagedObject
        
        var id = getMaxId() + 1
        
         newUser.setValue(id, forKey: "id")
        
        newUser.setValue(username, forKey: "username")
      
        
        newUser.setValue(language , forKey:  "language")
        
        newUser.setValue(gameNumber, forKey: "game_number")
        
        
        context.save(nil )
        println("You are login")
        
    }
    
    func getMaxId()-> Int{
        
        var arrID:Array<Int> = []
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Settings");
        
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
    
    
    
    func getLoggedUser() -> String {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Settings");
        
        request.returnsObjectsAsFaults = false ;
        
       
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
      
       
        if(results.count  == 1){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
         
                
                let pomUsername = pom.valueForKey("username") as String
                
              
                
                return  pomUsername
                
            }
        }else{
                return ""
        }
        return ""
        
    }
    
    
    
    
    

    
   public   func deleteFromDB(){
        
        var MyList: Array<AnyObject>   = []
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Settings")
         MyList = context.executeFetchRequest(request, error: nil)!
        
       
            
        var bas: AnyObject!
        
        
        for bas: AnyObject in MyList
        {
            context.deleteObject(bas as NSManagedObject)
        }
        
        context.save(nil )
            
        
    
        
        println("You log out")
    }

    
}
