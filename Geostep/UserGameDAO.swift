//
//  UserGameDAO.swift
//  Geostep
//
//  Created by Wind on 20/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserGameDAO {

    
    func saveToDB ( status:Int  , activeClueNumber :Int,  fkUserID : String , fkGameID: String){
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext =  appDel.managedObjectContext!
        
        
        var newObject = NSEntityDescription.insertNewObjectForEntityForName("User_table_game", inManagedObjectContext: context) as NSManagedObject
        
        var id = getMaxId()
        
        newObject.setValue(id, forKey: "id")
        newObject.setValue(status, forKey: "status")
        newObject.setValue(activeClueNumber , forKey: "active_clue_number")
        newObject.setValue(fkUserID, forKey: "fk_user_id")
        newObject.setValue(fkGameID , forKey: "fk_game_id")
    
        context.save(nil )
        println("add in  user table game")
        
    }
    
    
    func getMaxId()-> Int{
        
        var arrID:Array<Int> = []
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table_game");
        
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

    
    
    func getAllIDForGame(userID:String)->Array<String>{
        var arr:Array<String> = []
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table_game");
        
        request.returnsObjectsAsFaults = false ;
        request.predicate = NSPredicate(format: "fk_user_id = %@", userID)
        
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                let name = pom.valueForKey("fk_game_id") as String
                
                
                arr.append(name)
                
                
            }
        }
        
        return arr
    }
    
   
    
    
    
    func checkExistGame(userID:String , gameID:String )->Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table_game");
        
        request.returnsObjectsAsFaults = false ;
        
        // make query
        

        
        let predicate1 = NSPredicate (format: "fk_user_id == %@", userID)
        let predicate2 = NSPredicate (format: "fk_game_id == %@", gameID)
        
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [predicate1!, predicate2! ])
        
        request.predicate = predicate
        
        //
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
       

        
        if(results.count > 0 ){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
          
                let fkUserID = pom.valueForKey("fk_user_id") as String
                let fkGameID = pom.valueForKey("fk_game_id") as String
            
                if(userID == fkUserID && gameID == fkGameID){
                
                   
                    return true
                }
            }
        }
         return false
        
    }
    
    
    
    
     func getFromDB(){
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User_table_game");
        
        request.returnsObjectsAsFaults = false ;
        
      
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
              
                
                
                println( pom);
                
                
            }
        }else{
            println("DB is empty")
            
        }
        
    }
    
    func deleteFromDB(){
        
        var MyList: Array<AnyObject>   = []
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "User_table_game")
        MyList = context.executeFetchRequest(request, error: nil)!
        
     
        
        var bas: AnyObject!
        
        
        for bas: AnyObject in MyList
        {
            context.deleteObject(bas as NSManagedObject)
        }
        
        context.save(nil )
        
        
        
        
        println("Delete all from  User table game")
    }
    



}
