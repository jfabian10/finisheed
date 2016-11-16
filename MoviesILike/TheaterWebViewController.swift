//
//  TheaterWebViewController.swift
//  MoviesILike
//
//  Created by Luis Villavicencio  on 11/14/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class TheaterWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    var dataObjectPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = dataObjectPassed[0]
        self.title = dataObjectPassed[1]
        print(query)
        let url: URL? = URL(string: query)
        
        let request = URLRequest(url: url!)

        webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
