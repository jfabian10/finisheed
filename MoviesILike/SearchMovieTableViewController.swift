//
//  SearchMovieTableViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/17/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class SearchMovieTableViewController: UITableViewController {
    
    // Instance variables
    
    let tableViewRowHeight: CGFloat = 90.0
    var arrayOfMovieDictionaries = [AnyObject]()
    var listOfMoviesFound = [AnyObject]()
    var numberOfMoviesToDisplay = 0
    
    var movieDataToPass = [String: AnyObject]() ///used to pass information about movie to next VC
    
    
    var movieNameToSearchPassed: String?
    
    /*
     
     -----------------------
     
     MARK: - View Life Cycle
     
     -----------------------
     
     */
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        //print(movieNameToSearchPassed)
        var dictionaryOfMoviesFound = [String: AnyObject]()
        
        
        
        // Since a URL cannot have spaces, replace each space in the movie name to search with +.
        
        let movieNameToSearch = movieNameToSearchPassed!.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
        print(movieNameToSearch)
        
        // This URL returns the JSON data of the movies found for the search query movieNameToSearch as in STEP 1
        
        let apiURL = "http://api.themoviedb.org/3/search/movie?api_key=dd424332d7b9f6b37f3aeaab413fbca7&query=\(movieNameToSearch)"
        // Create a URL object from the API URL string
        
        let url = URL(string: apiURL)
        
        var jsonError: NSError?
        
        let jsonData: Data?
        
        do {
            
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.dataReadingMapped)
            
            
        } catch let error as NSError {
            
            jsonError = error
            
            jsonData = nil
            
        }
        
        
        if let jsonDataFromApiUrl = jsonData {
            
            // JSON data is successfully retrieved
            
            do {
                
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                
                dictionaryOfMoviesFound = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                
                
                // listOfMoviesFound is an Array of Dictionaries, where each Dictionary contains data about a movie
                listOfMoviesFound = dictionaryOfMoviesFound["results"] as! Array<AnyObject>
                
                let numberOfMoviesFromJsonData = listOfMoviesFound.count
                if numberOfMoviesFromJsonData < 1 {
                    
                    showNoMoviesFoundMessage()
                    return
                }
                
                
                
                // Select no more than 50 movies to display using the Ternary Conditional Operator
                
                numberOfMoviesToDisplay = numberOfMoviesFromJsonData > 50 ? 50 : numberOfMoviesFromJsonData
                
                
                
                // Declaration of local variables
                
                var posterImageURL: String?
                
                var movieTitle: String?
                
                var movieDescription: String?
                
                var releaseDate: String?
                
                var mpaaRating: String?
                
                var imdbRating: String?
                
                var runtime: String?
                
                var actors: String?
                
                
                for j in 0..<numberOfMoviesToDisplay {
                    
                    
                    
                    let movieDictionary = listOfMoviesFound[j] as! Dictionary<String, AnyObject>
                    
                    let posterImageFilenameFromJson: AnyObject? = movieDictionary["poster_path"]
                    
                    if var posterImageFilename = posterImageFilenameFromJson as? String {
                        
                        if !posterImageFilename.isEmpty && posterImageFilename != "<null>" {
                            
                            
                            // Delete the first \ character
                            
                            posterImageFilename.remove(at: posterImageFilename.startIndex)
                            
                            // Add the first part of the URL with image size w185
                            
                            posterImageURL = "http://image.tmdb.org/t/p/w185/" + posterImageFilename
                            
                            
                        } else {
                            
                            posterImageURL = "unavailable"
                            
                        }
                        
                    } else {
                        
                        posterImageURL = "unavailable"
                        
                    }
                    
                    //movie title
                    let movieTitleFromJson: String? = movieDictionary["title"] as! String?
                    
                    if let movieTitleObtained = movieTitleFromJson {
                        
                        if !movieTitleObtained.isEmpty {
                            
                            movieTitle = movieTitleObtained
                        } else {
                            
                            movieTitle = "No movie title is available!"
                            
                        }
                        
                        
                    } else {
                        
                        movieTitle = "No movie title is available!"
                        
                    }
                    
                    
                    
                    //------------------
                    
                    // Movie Description
                    
                    //------------------
                    
                    
                    
                    let movieDescriptionFromJson: String? = movieDictionary["overview"] as! String?
                    
                    
                    
                    if let movieDescriptionObtained = movieDescriptionFromJson {
                        
                        
                        
                        if !movieDescriptionObtained.isEmpty {
                            
                            
                            
                            movieDescription = movieDescriptionObtained
                            
                            
                            
                        } else {
                            
                            movieDescription = "No movie description is available!"
                            
                        }
                        
                        
                        
                    } else {
                        
                        movieDescription = "No movie description is available!"
                        
                    }
                    
                    
                    
                    //-------------
                    
                    // Release Date
                    
                    //-------------
                    
                    
                    
                    let movieReleaseDateFromJson: String? = movieDictionary["release_date"] as! String?
                    
                    
                    
                    if let movieReleaseDateObtained = movieReleaseDateFromJson {
                        
                        
                        
                        if !movieReleaseDateObtained.isEmpty {
                            
                            
                            
                            releaseDate = movieReleaseDateObtained
                            
                            
                            
                        } else {
                            
                            releaseDate = "No movie release date is available!"
                            
                        }
                        
                        
                        
                    } else {
                        
                        releaseDate = "No movie release date is available!"
                        
                    }
                    
                    
                    
                    /*
                     
                     =============================================
                     
                     |  Obtain Other Data from OMDb: STEP 2 & 3  |
                     
                     =============================================
                     
                     */
                    
                    
                    
                    let movieDBIdFromJson = movieDictionary["id"] as! Int
                    
                    
                    
                    let imdbMovieID: String? = imdbId(movieDatabaseID: movieDBIdFromJson)
                    
                    
                    
                    if let imdbMovieIDobtained = imdbMovieID {
                        
                        
                        
                        if imdbMovieIDobtained.isEmpty {
                            
                            // Skip this movie due to insufficient data
                            
                            break
                            
                        }
                        
                        
                        
                        let omdbMovie = omdbMovieDictionary(imdbDatabaseID: imdbMovieIDobtained) as Dictionary<String, AnyObject>
                        
                        
                        
                        //------------
                        
                        // MPAA Rating
                        
                        //------------
                        
                        
                        
                        let mpaaRatingFromJson: String? = omdbMovie["Rated"] as! String?
                        
                        
                        
                        if let mpaaRatingObtained = mpaaRatingFromJson {
                            
                            
                            
                            if !mpaaRatingObtained.isEmpty {
                                
                                
                                
                                mpaaRating = mpaaRatingObtained
                                
                                
                                
                            } else {
                                
                                mpaaRating = "MPAA rating is unavailable!"
                                
                            }
                            
                            
                            
                        } else {
                            
                            mpaaRating = "MPAA rating is unavailable!"
                            
                        }
                        
                        ///imdb rating
                        let imdbRatingFromJson: String? = omdbMovie["imdbRating"] as! String?
                        
                        
                        
                        if let imdbRatingObtained = imdbRatingFromJson {
                            
                            
                            
                            if !imdbRatingObtained.isEmpty {
                                
                                
                                
                                imdbRating = imdbRatingObtained
                                
                                
                                
                            } else {
                                
                                imdbRating = "IMDb rating is unavailable!"
                                
                            }
                            
                            
                            
                        } else {
                            
                            imdbRating = "IMDb rating is unavailable!"
                            
                        }
                        
                        
                        
                        //--------------
                        
                        // Movie Runtime
                        
                        //--------------
                        
                        
                        
                        let runtimeFromJson: String? = omdbMovie["Runtime"] as! String?
                        
                        
                        
                        if let runtimeObtained = runtimeFromJson {
                            
                            
                            
                            if !runtimeObtained.isEmpty {
                                
                                
                                
                                runtime = runtimeObtained
                                
                                
                                
                            } else {
                                
                                runtime = "Movie runtime is unavailable!"
                                
                            }
                            
                            
                            
                        } else {
                            
                            runtime = "Movie runtime is unavailable!"
                            
                        }
                        
                        
                        
                        //-------------
                        
                        // Movie Actors
                        
                        //-------------
                        
                        
                        
                        let actorsFromJson: String? = omdbMovie["Actors"] as! String?
                        
                        
                        
                        if let actorsObtained = actorsFromJson {
                            
                            
                            
                            if !actorsObtained.isEmpty {
                                
                                
                                
                                actors = actorsObtained
                                
                                
                                
                            } else {
                                
                                actors = "Actors are unavailable!"
                                
                            }
                            
                            
                            
                        } else {
                            
                            actors = "Actors are unavailable!"
                            
                        }
                        
                        
                        
                        //----------------------------------------------------------------------
                        
                        // Create a new movie dictionary with the following KEY : VALUE pairings
                        
                        //----------------------------------------------------------------------
                        
                        
                        
                        let newMovieDictionary = ["posterImageURL": posterImageURL,
                                                  
                                                  "movieTitle": movieTitle,
                                                  
                                                  "movieDescription": movieDescription,
                                                  
                                                  "releaseDate": releaseDate,
                                                  
                                                  "mpaaRating": mpaaRating,
                                                  
                                                  "imdbRating": imdbRating,
                                                  
                                                  "runtime": runtime,
                                                  
                                                  "actors": actors]
                        
                        
                        
                        // Add the new movie dictionary to the array of movie dictionaries
                        
                        self.arrayOfMovieDictionaries.append(newMovieDictionary as AnyObject)
                        
                        
                        
                    } else {
                        
                        // Skip this movie due to insufficient data
                        
                        break
                        
                    }
                    
                    
                    
                }
                
                
                
            } catch let error as NSError {
                
                
                
                showErrorMessage(title: "Error in JSON Data Serialization!", message: "Problem Description: \(error.localizedDescription)")
                
                return
                
            }
        } else {
            
            showErrorMessage(title: "Error in retrieving JSON data!", message: "Problem Description: \(jsonError!.localizedDescription)")
            
        }
        // Skipping movies due to insufficient data makes this test required
        
        if arrayOfMovieDictionaries.count == 0 {
            
            showNoMoviesFoundMessage()
            return
        }
        
        
    }
    
    
    
    /*
     
     ----------------------------
     
     MARK: - Obtain IMDb Movie ID
     
     ----------------------------
     
     */
    
    func imdbId(movieDatabaseID id: Int) -> String {
        
        
        
        let apiURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=dd424332d7b9f6b37f3aeaab413fbca7&append_to_response=credits"
        
        
        
        // Create a URL object from the API URL string
        
        let url = URL(string: apiURL)
        
        
        
        var jsonError: NSError?
        
        
        
        let jsonData: Data?
        
        do {
            
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.dataReadingMapped)
            
            
            
        } catch let error as NSError {
            
            jsonError = error
            
            jsonData = nil
            
        }
        
        
        
        if let jsonDataFromApiUrl = jsonData {
            
            
            
            // JSON data is successfully retrieved
            
            
            
            do {
                
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                
                let dictionaryOfMovieFromJson = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                
                
                let imdbMovieIDfromJson: AnyObject? = dictionaryOfMovieFromJson["imdb_id"]
                
                
                
                if let imdbMovieIdObtained = imdbMovieIDfromJson as? String {
                    
                    
                    
                    let imdbMovieID = imdbMovieIdObtained
                    
                    
                    
                    if !imdbMovieID.isEmpty && imdbMovieID != "<null>" {
                        
                        
                        
                        return imdbMovieID
                        
                        
                        
                    } else {
                        
                        return ""
                        
                    }
                    
                    
                    
                } else {
                    
                    return ""
                    
                }
                
                
                
            } catch let error as NSError {
                
                
                
                showErrorMessage(title: "Error in IMDb JSON Data Serialization!", message: "Problem Description: \(error.localizedDescription)")
                
                return ""
                
            }
            
            
            
        } else {
            
            showErrorMessage(title: "Error in retrieving IMDb JSON data!", message: "Problem Description: \(jsonError!.localizedDescription)")
            
        }
        
        
        
        return ""
        
    }
    
    
    
    /*
     
     ------------------------------------
     
     MARK: - Obtain OMDb Movie Dictionary
     
     ------------------------------------
     
     */
    
    func omdbMovieDictionary(imdbDatabaseID id: String) -> Dictionary<String, AnyObject> {
        
        
        
        let apiURL = "http://www.omdbapi.com/?i=\(id)&plot=full&r=json"
        
        
        
        // Create a URL object from the API URL string
        
        let url = URL(string: apiURL)
        
        
        
        var jsonError: NSError?
        
        
        
        let jsonData: Data?
        
        do {
            
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.dataReadingMapped)
            
            
        } catch let error as NSError {
            jsonError = error
            jsonData = nil
        }
        
        var dictionaryOfMovieFromJson = [String: AnyObject]()
        
        
        if let jsonDataFromApiUrl = jsonData {
            
            
            // JSON data is successfully retrieved
            
            do {
                
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                
                dictionaryOfMovieFromJson = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                return dictionaryOfMovieFromJson
                
            } catch let error as NSError {
                
                showErrorMessage(title: "Error in OMDb JSON Data Serialization!", message: "Problem Description: \(error.localizedDescription)")
                
                
                return dictionaryOfMovieFromJson
                
            }
            
        } else {
            
            showErrorMessage(title: "Error in retrieving OMDb JSON data!", message: "Problem Description: \(jsonError!.localizedDescription)")
            
        }
        return dictionaryOfMovieFromJson
    }
    /*
     
     -----------------------------
     
     MARK: - Display Error Message
     
     -----------------------------
     
     */
    
    func showErrorMessage(title errorTitle: String, message errorMessage: String) {
        
        
        
        /*
         
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         
         and store its object reference into local constant alertController
         
         */
        
        let alertController = UIAlertController(title: "\(errorTitle)",
            
            message: "\(errorMessage)",
            
            preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        // Create a UIAlertAction object and add it to the alert controller
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        
        
        // Present the alert controller
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    //no movies found message
    func showNoMoviesFoundMessage() {
        
        
        
        let alertController = UIAlertController(title: "No Movies Found!",
                                                
                                                message: "Please enter another search query!",
                                                
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            
            
            
            // When the user taps the OK button, show the Movie Search view
            
            self.navigationController!.popToRootViewController(animated: true)
            
        }
        
        // Add okAction to the alert controller
        
        alertController.addAction(okAction)
        
        // Present the alert controller
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    /*
     
     --------------------------------------
     
     MARK: - Table View Data Source Methods
     
     --------------------------------------
     
     */
    
    
    
    // Asks the data source to return the number of sections in the table view
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMovieDictionaries.count
    }
    
    
    
    /*
     
     ------------------------------------
     
     Prepare and Return a Table View Cell
     
     ------------------------------------
     
     */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        
        // MovieCell, which was specified in the storyboard
        
        let cell: MoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MoviesTableViewCell
        
        // Obtain the Dictionary containing the data about the movie at rowNumber
        
        let movieDataDict = arrayOfMovieDictionaries[rowNumber] as! Dictionary<String, AnyObject>
        
        //set poster image
        let posterUrl = movieDataDict["posterImageURL"] as! String
        
        if posterUrl != "unavailable" {
            
            let url = URL(string: posterUrl)
            
            var imageData: Data?
            
            do {
                imageData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
                
            } catch let error as NSError {
                
                print("Error occurred: \(error.localizedDescription)")
                
                imageData = nil
                
            }
            
            if let moviePosterImage = imageData {
                
                // Movie poster image data is successfully retrieved
                
                cell.moviePosterImageView!.image = UIImage(data: moviePosterImage)
                
            } else {
                
                cell.moviePosterImageView!.image = UIImage(named: "noPosterImage.png")
                
            }
            
        } else {
            
            cell.moviePosterImageView!.image = UIImage(named: "noPosterImage.png")
        }
        
        //set movie title
        let movieTitle = movieDataDict["movieTitle"] as! String
        
        cell.movieTitleLabel!.text = movieTitle
        
        ///set imdb rating
        let imdbRating = movieDataDict["imdbRating"] as! String
        
        cell.imdbRatingLabel!.text = imdbRating
        //set top three movie stars
        
        let topArtists = movieDataDict["actors"] as! String
        
        cell.movieStarsLabel!.text = topArtists
        
        //Set MPAA Rating, Runtime, and Release Date
        let mpaaRating = movieDataDict["mpaaRating"] as! String
        
        let runtime = movieDataDict["runtime"] as! String
        
        let releaseDate = movieDataDict["releaseDate"] as! String
        
        cell.mpaaRatingRuntimeDateLabel!.text = "\(mpaaRating), \(runtime), \(releaseDate)"
        
        return cell
        
    }
    
    //TABLE VIEW DELEGATES
    
    // Asks the table view delegate to return the height of a given row.
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    // Informs the table view delegate that the specified row is selected.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        
        // Obtain the Dictionary containing the data about the selected movie to pass to the downstream view controller
        movieDataToPass = arrayOfMovieDictionaries[rowNumber] as! Dictionary<String, AnyObject>
        performSegue(withIdentifier: "MovieInfo", sender: self)
    }
    
    ///
    
    ///prepares segue
    override func prepare(for segue: UIStoryboardSegue, sender:Any!){
        if segue.identifier == "MovieInfo"{
            let movieInfoVC: MovieInfoViewController = segue.destination as! MovieInfoViewController
            movieInfoVC.movieInfoPassed = self.movieDataToPass
        }
    }

}
