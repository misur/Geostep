//
//  GameDAO.swift
//  Geostep
//
//  Created by Wind on 20/04/15.
//  Copyright (c) 2015 Wind. All rights reserved.
//
import Foundation
import CoreData
import UIKit

class GameDAO {
    

    
    
    func saveToDB ( descrip:String  , distance :Double ,  gameNumber : Int , isOutdoors: Int, isTimeAttack: Int, name: String , time: Int , validForm: String , validTo: String){
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext =  appDel.managedObjectContext!
        
        
        var newObject = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: context) as NSManagedObject
        
        
       var id = getMaxId() + 1
        
        newObject.setValue(id , forKey: "id")
        newObject.setValue(descrip , forKey: "descrip")
        newObject.setValue(distance , forKey: "distance")
        newObject.setValue(gameNumber, forKey: "game_number")
        newObject.setValue(isOutdoors , forKey: "is_outdoors")
        
        newObject.setValue(isTimeAttack , forKey: "is_time_attack")
        
        newObject.setValue(name , forKey: "name")
        newObject.setValue(time, forKey: "time")
        
      
        
        newObject.setValue(validForm , forKey: "valid_from")
        newObject.setValue(validTo , forKey: "valid_to")
        
        
        context.save(nil )
        println("add in  table game")
        
    }
    
    func getMaxId()-> Int{
        
        var arrID:Array<Int> = []
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
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

    
    
    func getIdFor(gameNumber: Int)->String {
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        
        // make query
        
        request.predicate = NSPredicate(format: "game_number == %@", gameNumber as NSNumber)
        //
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                let s:Int  = pom.valueForKey("id")as Int
                return "\(s)"                
                
            }
        }else{
            return ""
        }
        return ""
    }
    
    
    func checkExistGame(gameNumber:Int)->Bool {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        
        // make query
        
        request.predicate = NSPredicate(format: "game_number == %@", gameNumber as NSNumber)
        //
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count == 1){
            
                return true
            
        }else{
            return false
        }
        
       
    }
    
    func getGameForLoggedUser()->Array<String>{
        var arr:Array<String>=[]
       /*
        let settingsDAO = SettingsDAO()
        var loggedUser:String = settingsDAO.getFromDB()
        let userDAO = UserDAO()
        let idLoggedUser = userDAO.getIdFor(loggedUser)
        let userGameDAO =  UserGameDAO()
        let arrGameIDs:Array<String> = userGameDAO.getAllIDForGame(idLoggedUser)
        
        for item in arrGameIDs {
          arr.append(self.getNameByID(item))
        }
        **/
        
        return arr
    }
    
    func getInfoByName(name:String )->(descript:String, outdoors:String , isTimeAttack: String){
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        // make query
        
        request.predicate = NSPredicate(format: "name == %@", name )
        //
        
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count == 1){
            
            var pom = results[0] as NSManagedObject
            
            let descript =   pom.valueForKey("descrip") as String
            let outdoors =   pom.valueForKey("is_outdoors") as Int
            let isTimeAtt =   pom.valueForKey("is_time_attack") as Int
            return (descript, "\(outdoors)", "\(isTimeAtt)") 
        }
        
        return ("","","")
        
    }
    
    
    func getNameByID(id:String )->String{
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        // make query
        
        request.predicate = NSPredicate(format: "id == %@", id )
        //
       
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count == 1){
            
                var pom = results[0] as NSManagedObject
                
                return  pom.valueForKey("name") as String 
            
        }
        
        return ""
        
    }
    
    
    func  getAllGame()->Array<String>{
        
        var arr:Array<String>   = []
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        
        
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                let name = pom.valueForKey("name") as String
                
              
                arr.append(name)
                
                                
            }
        }
        
        return arr
        
    }
    
    
    
    func getFromDB(){
        
        
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "Game");
        
        request.returnsObjectsAsFaults = false ;
        
      
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if(results.count > 0){
            for var i = 0; i < results.count; ++i {
                var pom = results[i] as NSManagedObject
                
                
                
                
                println( "game: \(pom)   ");
                
                
            }
        }else{
            println("DB is empty")
            
        }
       
    }
    
    
   
    
    
    
    
    func deleteFromDB(){
        
        var MyList: Array<AnyObject>   = []
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Game")
        MyList = context.executeFetchRequest(request, error: nil)!
     var bas: AnyObject!
        
        
        for bas: AnyObject in MyList
        {
            context.deleteObject(bas as NSManagedObject)
        }
        
        context.save(nil )
        
        
        
        
        println("Delete all game")
    }

    
    
}