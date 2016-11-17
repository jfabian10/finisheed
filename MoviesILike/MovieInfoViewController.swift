//
//  MovieInfoViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/17/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class MovieInfoViewController: UIViewController {

    var movieInfoPassed = [String: AnyObject]()
    
    @IBOutlet var movieTitleNavItem: UINavigationItem!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var ratingAndRuntimeLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var imdbRating: UILabel!
    
    @IBOutlet var castTextView: UITextView!
    @IBOutlet var movieInfoTextView: UITextView!
    
    
    //TODO fix to portrait mode only
    
    override func viewDidLoad() {
        //print(movieInfoPassed)
        super.viewDidLoad()
        
        movieTitleNavItem.title = movieInfoPassed["movieTitle"] as? String
        
        let movieRating = movieInfoPassed["mpaaRating"] as? String
        let runtime = movieInfoPassed["runtime"] as? String
        let movieRatingAndRuntime = movieRating! + "," + runtime!
        
        ratingAndRuntimeLabel.text = movieRatingAndRuntime
        
        releaseDateLabel.text = movieInfoPassed["releaseDate"] as? String
        imdbRating.text = movieInfoPassed["imdbRating"] as? String
        
        
        let imageURLString = movieInfoPassed["posterImageURL"] as? String
        let imageURL = URL(string: imageURLString!)
        
        let data = NSData(contentsOf: imageURL!)
        moviePosterImageView.image = UIImage(data: data as! Data)
        
        
        castTextView.text = movieInfoPassed["actors"] as? String
        print(castTextView.text)
        movieInfoTextView.text = movieInfoPassed["movieDescription"] as? String
    }
    
    //following will fix to portrait mode
          override func viewDidAppear(_ animated: Bool) {
                let portraitValue = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(portraitValue, forKey: "orientation")
                UIViewController.attemptRotationToDeviceOrientation()
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
