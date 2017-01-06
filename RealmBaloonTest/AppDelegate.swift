//
//  AppDelegate.swift
//  RealmBaloonTest
//
//  Created by Jon Vogel on 1/5/17.
//  Copyright © 2017 Jon Vogel. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //This Set up Realm as a custom file
        PBConfiguration.defaultConfiguration?.addAppID("123456789")
        
        return true
        
        //Get My custom Realm
        guard let realm = PBConfiguration.defaultConfiguration?.pebblebeeRealm else {
            return true
        }
        
        //Add 100 objects
        for index in 0...100 {
            let newObject = AnObject()
            newObject.someInt = index
            do{
                try realm.write {
                    realm.add(newObject)
                }
            }catch{
                print(error)
            }
        }
        
        //Get all objects
        let allObject = realm.objects(AnObject.self)
        
        print("\(allObject.count) Objects")
        
        //If I have more than 100 objects I want to remove everything but 100 objects.
        guard allObject.count > 100 else{
            return true
        }
        
        
        //Make List to hold everything but 100 objects
        let objectsToRemove = List<AnObject>()
        
        
        //Tried allObject[0...(allObject.count - 101)] but I get an out of range error. So I do the below loop to build a valid `List` object
        
        //Enumerate all objects and add everthing but the last 100 objects to the `objectsToRemove` array
        for (index, value) in allObject.enumerated() {
            
            if index < (allObject.count - 101) {
                objectsToRemove.append(value)
            }
        }
        
        print("About to remove \(objectsToRemove.count) Objects")
        
        //Remove everthing but 100 objects
        do{
            try realm.write {
                realm.delete(objectsToRemove)
            }
        }catch{
            print("\(error)")
        }
        
        
        print("\(realm.objects(AnObject.self).count) Object Left")
        
        
        guard let realmSize = PBConfiguration.defaultConfiguration?.checkRealmFileSize().0 else{
            return true
        }
        
        print("Realm File Size is now \(realmSize) Gigabytes. Was \(PBConfiguration.defaultConfiguration?.fileSizeOnInitalization) Gigabytes on Initalization.")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

