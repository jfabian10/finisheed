//
//  MovieVideoViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/13/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class MovieVideoViewController: UIViewController{

    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var movieTitleNavLabel: UINavigationItem!
    
    var dataPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataPassed)
        
        // Adjust the title to fit within the navigation bar
        let labelRect = CGRect(x: 0, y: 0, width: 300, height: 42)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = dataPassed[0] // Movie Title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        
        ///need to make URL
        let youTubeURL = URL(string: "http://www.youtube.com/embed/\(dataPassed[1])")
        let request = URLRequest(url: youTubeURL!)
        webView.loadRequest(request)
    }
    
    //forces it to be landscape mode
    override func viewDidAppear(_ animated: Bool) {
        let landscapeValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

}
