//
//  AppDelegate.swift
//  MoviesILike
//
//  Created by CS3714 on 11/11/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved. fafa
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dict_Movie_Genres: NSMutableDictionary = NSMutableDictionary()
    //var dict_movieGenre = [String: AnyObject]()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentDirectoryPath = paths[0] as String
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/MyFavoriteMovies.plist"
        /*
         
         NSMutableDictionary manages an *unordered* collection of mutable (modifiable) key-value pairs.
         
         Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
         */
        
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            // MyFavoriteMovies.plist exists in the Document directory
            
            dict_Movie_Genres = dictionaryFromFileInDocumentDirectory
            
            
            
        } else {
            
            //  MyFavoriteMovies.plist does not exist in the Document directory; Read it from the main bundle.
            // Obtain the file path to the plist file in the mainBundle (project folder)
            
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "MyFavoriteMovies", ofType: "plist")

            // Instantiate an NSMutableDictionary object and initialize it with the contents of the  MyFavoriteMovies.plist file.
            
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            
            dict_Movie_Genres = dictionaryFromFileInMainBundle!
            
        }
        
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

