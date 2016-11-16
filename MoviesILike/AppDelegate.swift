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
    var dict_Theaters: NSMutableDictionary = NSMutableDictionary()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentDirectoryPath = paths[0] as String
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/MyFavoriteMovies.plist"
        
        let plistTheatersFilePathInDocumentDirectory = documentDirectoryPath + "/MyFavoriteTheaters.plist"
        /*
         
         NSMutableDictionary manages an *unordered* collection of mutable (modifiable) key-value pairs.
         
         Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
         */
        
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)

        let dictionaryTheatersFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistTheatersFilePathInDocumentDirectory)
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
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
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryTheatersFromFile {
            dict_Theaters = dictionaryFromFileInDocumentDirectory
        } else {
            let theaterPlistPath = Bundle.main.path(forResource: "MyFavoriteTheaters", ofType: "plist")
            let dictTheaterFromFileInBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: theaterPlistPath!)
            
            dict_Theaters = dictTheaterFromFileInBundle!
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        /*
         "UIApplicationWillResignActiveNotification is posted when the app is no longer active and loses focus.
         An app is active when it is receiving events. An active app can be said to have focus.
         It gains focus after being launched, loses focus when an overlay window pops up or when the device is
         locked, and gains focus when the device is unlocked." [Apple]
         */
        
        let plistFilePathInMainBundle = Bundle.main.path(forResource: "MyFavoriteMovies", ofType: "plist")

        // Write the NSMutableDictionary to the file in the Document directory
        dict_Movie_Genres.write(toFile: plistFilePathInMainBundle!, atomically: true)
        
        let theaterPlistPath = Bundle.main.path(forResource: "MyFavoriteTheaters", ofType: "plist")
        
        dict_Theaters.write(toFile: theaterPlistPath!, atomically: true)
        /*
         The flag "atomically" specifies whether the file should be written atomically or not.
         
         If flag atomically is TRUE, the dictionary is first written to an auxiliary file, and
         then the auxiliary file is renamed to path plistFilePathInDocumentDirectory.
         
         If flag atomically is FALSE, the dictionary is written directly to path plistFilePathInDocumentDirectory.
         This is a bad idea since the file can be corrupted if the system crashes during writing.
         
         The TRUE option guarantees that the file will not be corrupted even if the system crashes during writing.
         */
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

