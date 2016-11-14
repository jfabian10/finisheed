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
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        
//        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCity method when tapped
        
//        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MovieTableViewController.addMovie(_:)))
        
//        self.navigationItem.rightBarButtonItem = addButton
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
       movieGenreList = applicationDelegate.dict_Movie_Genres.allKeys as! [String]
       movieGenreList.sort { $0 < $1 }  // Sort genres alphabetically
        
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
            ////need to check all three text fields have been filled and movie rating as well
            if (controller.movieTitleLabel.text == "" || controller.movieCastLabel.text == "" ||
                controller.youTubeLabel.text == "" ||
                controller.movieRatingLabel.selectedSegmentIndex == UISegmentedControlNoSegment){
                print("can't process")
            }
            let movieNameEntered: String = controller.movieTitleLabel.text!
            var movieCastEntered = ""
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
            print(movieNameEntered)
            print(movieCastEntered)
            print(movieYouTubeURLEntered)
            print(movieRatingEntered)
            print(movieGenreEntered)
            //print(movieGenreList[controller.pickerView.selectedRow(inComponent: 0)]) ///gets value selected from picker view
         }
    }
    
    
    
}
