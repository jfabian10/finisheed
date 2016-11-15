//
//  MovieTableViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/12/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved. yyy
//

import UIKit

class MovieTableViewController: UITableViewController{

    @IBOutlet var movieTableView: UITableView!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var movieGenreList = [String]() //all movie genres
    
    var dict_movieGenre = [String: AnyObject]()
    var dict_moviesForAGenre = [String: AnyObject]()
    

    
    var dataToPass: [String] = ["", ""] ///used to pass movie title and URL
    
    
    @IBAction func addMovie(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddMovie", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Preserve selection between presentations
        
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    
       movieGenreList = applicationDelegate.dict_Movie_Genres.allKeys as! [String]
       movieGenreList.sort { $0 < $1 }  // Sort genres alphabetically
        
    }
    //allows editing of rows
    //when user taps Edit table view will have red circle (delete) functionality for each cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //delete button tapped
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //obtain section number
            //let sectionNumber = (indexPath as NSIndexPath).section
            //obtain row number
            //let rowNumber = (indexPath as NSIndexPath).row
            
            let movieGenreToDelete = movieGenreList[(indexPath as NSIndexPath).section]
            //declares it as an NSMutableDictionary
            //let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[movieGenreToDelete]! as? NSMutableDictionary
            let movies: AnyObject? = applicationDelegate.dict_Movie_Genres[movieGenreToDelete]! as AnyObject
            
            //declares it like a Swift dictionary
            let dict_movies = movies as! NSMutableDictionary!
            
            var movieNameOG = [String]()
            movieNameOG = dict_movies?.allKeys as! [String]

            movieNameOG.sort()
            print(movieNameOG)

            //print(dict_movies)
            let dict_temp = NSMutableDictionary() //empty
            print(dict_movies?.value(forKey: "0"))
            var originalDictCounter = 0

            //let arrMovies = dict_movies?.allValues as! [[String]]
            print(dict_movies)
            
            ///we copy everything from original dictionary to temp skipping over the entry we want to delete
            while (originalDictCounter != movieNameOG.count){
                print("\(indexPath.row)")
                if (originalDictCounter != indexPath.row){
                    
                    dict_temp.setObject(movieNameOG[originalDictCounter], forKey: dict_movies?[originalDictCounter] as! NSCopying)
                }
                originalDictCounter += 1
            }
            
             print("\(dict_temp)")
            //updates plist to reflect changes
            applicationDelegate.dict_Movie_Genres.setValue(dict_temp, forKey: movieGenreToDelete)
            movieTableView.reloadData() ////CRASHES HERE
        }
        
        }
    
    
    //movement of movie allowed witin genre
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        print("dd")
        let movieGenreBeingEdited = movieGenreList[(fromIndexPath as NSIndexPath).section]
        let movies: AnyObject? = applicationDelegate.dict_Movie_Genres[movieGenreBeingEdited]! as AnyObject
        //print(movies)
 
    }
    
    // Allow Movement of Rows (movies) within their genre
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //return number of sections in table view
    override func numberOfSections(in tableView: UITableView) -> Int {
        return movieGenreList.count
        }
    

    
    //set table view section to be genre name
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return movieGenreList[section]
    }
    //return number of rows per movie genre
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let givenMovieGenre = movieGenreList[section]
        let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[givenMovieGenre]! as? NSMutableDictionary
        return movies.count;
    }
    
    //loads all of the table view's cells
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as UITableViewCell
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        let givenMovieGenre = movieGenreList[sectionNumber]
        
        let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[givenMovieGenre]! as? NSMutableDictionary
        var moviesForAGenre = movies![String(rowNumber + 1)] as! [String] ///name is deceptive...its actually the info array for a movie
        //print(moviesForAGenre)

        cell.textLabel!.text = moviesForAGenre[0]
        cell.detailTextLabel?.text = moviesForAGenre[1]
        cell.imageView!.image = UIImage(named: moviesForAGenre[3])
        return cell
    }
    
    ///when user taps cell
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as UITableViewCell
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        let givenMovieGenre = movieGenreList[sectionNumber]
        let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[givenMovieGenre]! as? NSMutableDictionary
        var moviesForAGenre = movies![String(rowNumber + 1)] as! [String]
        
       
        dataToPass[0] = moviesForAGenre[0]
        dataToPass[1] = moviesForAGenre[2]
        //print(dataToPass[0])
       // print(dataToPass[1])
        performSegue(withIdentifier: "ShowMovieTrailer", sender: self)
    }
    
    ///prepares segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowMovieTrailer" {
            let movietrailerWebViewController: MovieVideoViewController = segue.destination as! MovieVideoViewController
            movietrailerWebViewController.dataPassed = self.dataToPass
        }
        else if (segue.identifier == "AddMovie"){
            let addMovieVC: AddMovieViewController = segue.destination as! AddMovieViewController
            addMovieVC.dataPassed  = self.movieGenreList
        }
    }
    
    //the following extracts the text that was passed upstream after user click saved on AddMoviesVC
    @IBAction func unwindToMovieTableViewController(segue: UIStoryboardSegue){
        if segue.identifier == "AddMovie-Save"{
            print("addmovie")
            let controller: AddMovieViewController = segue.source as! AddMovieViewController
            
            //if a textfield was left empty or rating not picked from seg control view will display 
            //error message
            if (controller.movieTitleLabel.text == "" || controller.movieCastLabel.text == "" ||
                controller.youTubeLabel.text == "" || controller.movieRatingLabel.selectedSegmentIndex == UISegmentedControlNoSegment){
                let alertController1 = UIAlertController(title: "Oops!",
                                                         message: "Please fill out all textfields and pick a rating too",
                                                         preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController1.addAction(okAction)
                present(alertController1, animated: true, completion:  nil)
            }
            
            //gathers text from textfields from AddMovieVC
            let movieNameEntered: String = controller.movieTitleLabel.text!
            let movieCastEntered: String = controller.movieCastLabel.text!
            let movieYouTubeURLEntered: String = controller.youTubeLabel.text!
            var movieRatingEntered = ""
            
            let movieGenrePickedNum = controller.pickerView.selectedRow(inComponent: 0)
            let movieGenreEntered = movieGenreList[movieGenrePickedNum]
            
            //sets the genre for movie accordin to what user picked on seg control
            switch controller.movieRatingLabel.selectedSegmentIndex{
            case 0:
                movieRatingEntered = "G"
            case 1:
                movieRatingEntered = "PG"
            case 2:
                movieRatingEntered = "PG-13"
            case 3:
                movieRatingEntered = "R"
            case 4:
                movieRatingEntered = "NC-17"
            default:
                print("no selection....")
            }
            
            //gets dictionary for entered movie genre
            let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[movieGenreEntered]! as? NSMutableDictionary
            //print(movies.count)
            
            //array for added movie
            var newMovieArray: [String] = [String]()
            newMovieArray.append(movieNameEntered)
            newMovieArray.append(movieCastEntered)
            newMovieArray.append(movieYouTubeURLEntered)
            newMovieArray.append(movieRatingEntered)
            //print(newMovieArray)
            
            //adds new movie to dictionary
            movies.setObject(newMovieArray, forKey: "\(movies.count + 1)" as NSCopying)
            //print(movies)

         }
        tableView.reloadData()
    }
    
    
    
}
