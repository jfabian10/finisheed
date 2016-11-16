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
    
    @IBOutlet var theatersLocationInput: UITextField!
    @IBOutlet var theaterMapTypeSegmentedControl: UISegmentedControl!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var arrayTheaterNames = [String]()
    
    // Data to pass for map
    var dataMapQueryToPass: [String] = ["googleMapQuery", "theaterPlace"]
    
    var dataTheaterToPass: [String] = ["theterName", "theaterAddress"]
    
    // Instance variable to hold the absolute file path for the maps.html file
    var mapsHtmlFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(MyTheatersViewController.editTheater(_:)))
        self.navigationItem.leftBarButtonItem = editButton
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyTheatersViewController.addTheater(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        arrayTheaterNames = applicationDelegate.dict_Theaters.allKeys as! [String]
        arrayTheaterNames.sort { $0 < $1 }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyTheatersViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let numberOfTheaters = arrayTheaterNames.count
        let numberOfRowToShow = Int(numberOfTheaters/2)
        
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        theaterMapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        mapsHtmlFilePath = Bundle.main.path(forResource: "maps", ofType: "html")
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTheater(_ sender: AnyObject) {
        performSegue(withIdentifier: "AddTheater", sender: self)
    }
    
    func editTheater(_ sender: AnyObject) {
        let selectedRowNumber = pickerView.selectedRow(inComponent: 0)
        let theaterName = arrayTheaterNames[selectedRowNumber]
        let theaterAddress = applicationDelegate.dict_Theaters[theaterName]
        dataTheaterToPass[0] = theaterName
        dataTheaterToPass[1] = theaterAddress as! String
        
        performSegue(withIdentifier: "EditTheater", sender: self)
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

        dataMapQueryToPass[0] = googleMapQuery
        dataMapQueryToPass[1] = theaterName
        
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
    
    @IBAction func unwindToMyTheatersViewController (segue: UIStoryboardSegue) {
        if segue.identifier == "AddTheater-Save" {
            let controller: AddTheaterViewController = segue.source as! AddTheaterViewController
            
            let theaterNameEntered: String = controller.theaterNameTextField.text!
            let theaterAddressEntered: String = controller.theaterAddressTextField.text!
            
            checkTheaterExistence(theaterName: theaterNameEntered, theaterAddress: theaterAddressEntered)
        }
        
        if segue.identifier == "EditTheater-Save" {
            let controller: EditTheaterViewController = segue.source as! EditTheaterViewController
            
            let theaterNameEdited: String = controller.theaterNameTextField.text!
            let theaterAddressEdited: String = controller.theaterAddressTextField.text!
            
            checkTheaterExistence(theaterName: theaterNameEdited, theaterAddress: theaterAddressEdited)
        }
        
        if segue.identifier == "DeleteTheater" {
            let controller: EditTheaterViewController = segue.source as! EditTheaterViewController
            
            let theaterNameDelete: String = controller.theaterNameTextField.text!
            applicationDelegate.dict_Theaters.removeObject(forKey: theaterNameDelete)
        }
        
        arrayTheaterNames = applicationDelegate.dict_Theaters.allKeys as! [String]
        
        arrayTheaterNames.sort { $0 < $1 }
        
        pickerView.reloadAllComponents()
    }
    
    func checkTheaterExistence(theaterName: String, theaterAddress: String) {
            let dict = applicationDelegate.dict_Theaters
            dict[theaterName] = theaterAddress
            applicationDelegate.dict_Theaters = dict
            //applicationDelegate.dict_Theaters.setObject(theaterAddress, forKey: theaterName as NSCopying)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewTheater" {
            let theaterWebView: TheaterWebViewController = segue.destination as! TheaterWebViewController
            
            theaterWebView.theaterSelectedData = dataMapQueryToPass
        }
        
        if segue.identifier == "EditTheater" {
            let editTheater: EditTheaterViewController = segue.destination as! EditTheaterViewController
            
            editTheater.theaterSelectedData = dataTheaterToPass
        }
    }
}
