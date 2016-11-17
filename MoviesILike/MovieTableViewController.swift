//
//  MovieTableViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/12/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved. LETS GO HOME !!!!!
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
            let sectionNumber = (indexPath as NSIndexPath).section
           // obtain row number
            var rowNumber = (indexPath as NSIndexPath).row
            
            let movieGenreToDelete = movieGenreList[(indexPath as NSIndexPath).section]
            let moviesOfGenre: NSMutableDictionary = (applicationDelegate.dict_Movie_Genres[movieGenreToDelete]! as? NSMutableDictionary)!
            while (moviesOfGenre["\(rowNumber + 2)"] != nil) {
                moviesOfGenre.setValue(moviesOfGenre["\(rowNumber + 2)"], forKey: "\(rowNumber + 1)")
                rowNumber = rowNumber + 1;
            }
            moviesOfGenre.removeObject(forKey: "\(rowNumber + 1)");
            //resort dictioanry
            var movies = [String]()
            movies = moviesOfGenre.allKeys as! [String]
            movies.sort {$0 < $1}
            
        }
         movieTableView.reloadData()
        
    }
    
    //movement of movie allowed witin genre
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let sectionNumber = (fromIndexPath as NSIndexPath).section
        let fromRow = (fromIndexPath as NSIndexPath).row
        
        let toRow = (toIndexPath as NSIndexPath).row

        
        let movieGenreToEdit = movieGenreList[sectionNumber]
        let moviesOfGenre: NSMutableDictionary = (applicationDelegate.dict_Movie_Genres[movieGenreToEdit]! as? NSMutableDictionary)!

        let tempFrom = moviesOfGenre["\(fromRow + 1)"] as! [String]
        let tempTo = moviesOfGenre["\(toRow + 1)"] as! [String]
        
        moviesOfGenre.setValue(tempTo, forKey: "\(fromRow + 1)")
        moviesOfGenre.setValue(tempFrom, forKey: "\(toRow + 1)")
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
    
    
    //--------------------------
    
    // Movement of City Approval
    
    //--------------------------
    
    
    
    // This method is invoked when the user attempts to move a row (city)
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        
        
        let countryFrom = movieGenreList[(sourceIndexPath as NSIndexPath).section]
        
        let countryTo = movieGenreList[(proposedDestinationIndexPath as NSIndexPath).section]
        
        if countryFrom != countryTo {
            
            
            
            // The user attempts to move a city from one country to another, which is prohibited
            
            
            
            /*
             
             Create a UIAlertController object; dress it up with title, message, and preferred style;
             
             and store its object reference into local constant alertController
             
             */
            
            let alertController = UIAlertController(title: "Move Not Allowed!",
                                                    
                                                    message: "Order cities according to your liking only within the same country!",
                                                    
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            
            
            // Create a UIAlertAction object and add it to the alert controller
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        // Present the alert controller by calling the presentViewController method
            
            present(alertController, animated: true, completion: nil)
            return sourceIndexPath  // The row (city) movement is denied
            
        }
            
        else {
            
            return proposedDestinationIndexPath  // The row (city) movement is approved
            
        }
    }
    
    //loads all of the table view's cells
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as UITableViewCell
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        let givenMovieGenre = movieGenreList[sectionNumber]
        
        let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[givenMovieGenre]! as? NSMutableDictionary
        var moviesForAGenre = movies![String(rowNumber + 1)] as! [String] ///name is deceptive...its actually the info array for a movie

        cell.textLabel!.text = moviesForAGenre[0]
        cell.detailTextLabel?.text = moviesForAGenre[1]
        cell.imageView!.image = UIImage(named: moviesForAGenre[3])
        return cell
    }
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as UITableViewCell
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        let givenMovieGenre = movieGenreList[sectionNumber]
        let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[givenMovieGenre]! as? NSMutableDictionary
        var moviesForAGenre = movies![String(rowNumber + 1)] as! [String]
        
        dataToPass[0] = moviesForAGenre[0]
        dataToPass[1] = moviesForAGenre[2]

        performSegue(withIdentifier: "ShowMovieTrailer", sender: self)
    }
    
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
    
    @IBAction func unwindToMovieTableViewController(segue: UIStoryboardSegue){
        if segue.identifier == "AddMovie-Save"{
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
            let movieCastEntered = ""
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
                movieRatingEntered = "None"
            }
            
            let movies: NSMutableDictionary! = applicationDelegate.dict_Movie_Genres[movieGenreEntered]! as? NSMutableDictionary
            
            //array for added movie
            var newMovieArray: [String] = [String]()
            newMovieArray.append(movieNameEntered)
            newMovieArray.append(movieCastEntered)
            newMovieArray.append(movieYouTubeURLEntered)
            newMovieArray.append(movieRatingEntered)
            
            //adds new movie to dictionary
            movies.setObject(newMovieArray, forKey: "\(movies.count + 1)" as NSCopying)
         }
        tableView.reloadData()
    }
}
