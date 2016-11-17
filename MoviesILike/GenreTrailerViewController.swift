//
//  GenreTrailerViewController.swift
//  MoviesILike
//
//  Created by Jesus Fabian on 11/16/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class GenreTrailerViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var dataObjectPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = dataObjectPassed[0]
        let youTubeMovieTrailerID = dataObjectPassed[1]
        // Do any additional setup after loading the view.
        
        let youTubeURL = "http://www.youtube.com/embed/\(youTubeMovieTrailerID)"
        let url: URL? = URL(string: youTubeURL)
        
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
         --------------------------------------------------------------------
         Force this view to be displayed only in Landscape device orientation
         --------------------------------------------------------------------
         */
        let landscapeValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
