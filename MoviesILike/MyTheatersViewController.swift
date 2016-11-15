//
//  MyTheatersViewController.swift
//  MoviesILike
//
//  Created by Luis Villavicencio  on 11/14/16.
//  Copyright © 2016 Luis Villavicencio. All rights reserved.
//

import UIKit

class MyTheatersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var theaterMapTypeSegmentedControl: UISegmentedControl!
    
    var dict_Theater: NSMutableDictionary = NSMutableDictionary()
    
    var arrayTheaterNames = [String]()
    
    // Data to pass for map
    var dataObjectToPass: [String] = ["googleMapQuery", "theaterPlace"]
    
    // Instance variable to hold the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyTheatersViewController.addTheater(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        let theaterPlistPath = Bundle.main.path(forResource: "MyFavoriteTheaters", ofType: "plist")
        let dictTheaterFromFileInBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: theaterPlistPath!)
        
        dict_Theater = dictTheaterFromFileInBundle!
        
        arrayTheaterNames = dict_Theater.allKeys as! [String]
        arrayTheaterNames.sort { $0 < $1 }
        
        let numberOfTheaters = arrayTheaterNames.count
        let numberOfRowToShow = Int(numberOfTheaters/2)
        
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        theaterMapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        mapsHtmlFilePath = Bundle.main.path(forResource: "maps", ofType: "html")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTheater(_ sender: AnyObject) {
        performSegue(withIdentifier: "AddTheater", sender: self)
    }
    
    @IBAction func setMapType(_ sender: AnyObject) {
        var googleMapQuery: String = ""
        
        let selectedRowNumber = pickerView.selectedRow(inComponent: 0)
        
        let theaterName = arrayTheaterNames[selectedRowNumber]
        
        switch sender.selectedSegmentIndex {
        case 0: //RoadMap
            googleMapQuery = mapsHtmlFilePath!
        case 1: //SatelliteMap
            googleMapQuery = mapsHtmlFilePath!
        case 2: //HybridMap
            googleMapQuery = mapsHtmlFilePath!
        case 3: //TerrainMap
            googleMapQuery = mapsHtmlFilePath!
        default:
            return
        }
        
        dataObjectToPass[0] = googleMapQuery
        dataObjectToPass[1] = theaterName
        
        performSegue(withIdentifier: "theaterOnMap", sender: self)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayTheaterNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayTheaterNames[row]
    }
    
    @IBAction func unwindToTheaters(segue: UIStoryboardSegue) {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "theaterOnMap" {
            let theaterMap: TheaterWebViewController = segue.destination as! TheaterWebViewController
            
            theaterMap.theaterSelectedData = dataObjectToPass
        }
    }
 

}
