//
//  SearchMovieViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/17/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class SearchMovieViewController: UIViewController {
    @IBOutlet var searchedMovieText: UITextField!
    
    var movieNameToPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ///adds gesture recognizer to hide keyboard when user taps anywhere on background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMovieViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    //hides keyboard
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////hides keyboard when user taps Search
    @IBAction func textFieldShouldReturn(_ sender: UITextField) {
        searchedMovieText.resignFirstResponder()
        movieNameToPass = searchedMovieText.text! ////loads string name to pass to next VC
        searchedMovieText.text = ""
        performSegue(withIdentifier: "SearchedMovie", sender: self)
    }
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "SearchedMovie"{
            let searchMovieTableViewController: SearchMovieTableViewController = segue.destination as! SearchMovieTableViewController
            searchMovieTableViewController.movieNameToSearchPassed = self.movieNameToPass
        }
    }
}
