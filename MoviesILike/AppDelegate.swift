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
    
    var moviesPlist = "MyFavoriteMovies"
    var theatersPlist = "MyFavoriteTheaters"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Movies
        var sourceMoviesPath:String? {
            guard let path = Bundle.main.path(forResource: moviesPlist, ofType: "plist") else {
                return .none
            }
            return path
        }
        
        var destMoviesPath:String? {
            guard sourceMoviesPath != .none else {
                return .none
            }
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            return (dir as NSString).appendingPathComponent("\(moviesPlist).plist")
        }
        
        //Theaters
        var sourceTheatersPath:String? {
            guard let path = Bundle.main.path(forResource: theatersPlist, ofType: "plist") else {
                return .none
            }
            return path
        }
        
        var destTheatersPath:String? {
            guard sourceTheatersPath != .none else {
                return .none
            }
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            return (dir as NSString).appendingPathComponent("\(theatersPlist).plist")
        }
        
        let fileManager = FileManager.default

        //MOVIES
        guard let sourceMovies = sourceMoviesPath else { return false }
        guard let destinationMovies = destMoviesPath else { return false }
        
        guard fileManager.fileExists(atPath: sourceMovies) else { return false }
        
        if !fileManager.fileExists(atPath: destinationMovies) {
            do {
                try fileManager.copyItem(atPath: sourceMovies, toPath: destinationMovies)
                if fileManager.fileExists(atPath: destMoviesPath!) {
                    dict_Movie_Genres = NSMutableDictionary(contentsOfFile: destMoviesPath!)!
                } else {
                    return false
                }
            } catch let error as NSError {
                print("[PlistManager] Unable to copy file. ERROR: \(error.localizedDescription)")
                return false
            }
        } else {
            dict_Movie_Genres = NSMutableDictionary(contentsOfFile: destMoviesPath!)!
        }

        //THEATERS
        guard let sourceTheaters = sourceTheatersPath else { return false }
        guard let destinationTheaters = destTheatersPath else { return false }
        
        guard fileManager.fileExists(atPath: sourceTheaters) else { return false }
        
        if !fileManager.fileExists(atPath: destinationTheaters) {
            
            do {
                try fileManager.copyItem(atPath: sourceTheaters, toPath: destinationTheaters)
                
                if fileManager.fileExists(atPath: destTheatersPath!) {
                    dict_Theaters = NSMutableDictionary(contentsOfFile: destTheatersPath!)!
                } else {
                    return false
                }
            } catch let error as NSError {
                print("[PlistManager] Unable to copy file. ERROR: \(error.localizedDescription)")
                return false
            }
        } else {
            dict_Theaters = NSMutableDictionary(contentsOfFile: destTheatersPath!)!
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
        
        //Movies
        var sourceMoviesPath:String? {
            guard let path = Bundle.main.path(forResource: moviesPlist, ofType: "plist") else {
                return .none
            }
            return path
        }
        
        var destMoviesPath:String? {
            guard sourceMoviesPath != .none else {
                return .none
            }
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            return (dir as NSString).appendingPathComponent("\(moviesPlist).plist")
        }
        
        //Theaters
        var sourceTheatersPath:String? {
            guard let path = Bundle.main.path(forResource: theatersPlist, ofType: "plist") else {
                return .none
            }
            return path
        }
        var destTheatersPath:String? {
            guard sourceTheatersPath != .none else {
                return .none
            }
            let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            return (dir as NSString).appendingPathComponent("\(theatersPlist).plist")
        }
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        dict_Movie_Genres.write(toFile: destMoviesPath!, atomically: true)
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        dict_Theaters.write(toFile: destTheatersPath!, atomically: true)
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

