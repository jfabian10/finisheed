//
//  MyTheatersViewController.swift
//  MoviesILike
//
//  Created by Jesus Fabian on 11/14/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class MyTheatersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet var pickerView: UIPickerView!
    // Instance variable holding the object reference of the Scroll View object
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var theatersLocationInput: UITextField!
    @IBOutlet var theaterMapTypeSegmentedControl: UISegmentedControl!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Instance variable to hold the object reference of a Text Field object
    var activeTextField: UITextField?
    
    var arrayTheaterNames = [String]()
    
    // Data to pass for map
    var dataToPassWeb: [String] = ["googleQuery", "theaterPlace"]
    var googleQuery: String = ""
    
    var dataTheaterToPass: [String] = ["theaterName", "theaterAddress"]
    
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
        
        let numberOfTheaters = arrayTheaterNames.count
        let numberOfRowToShow = Int(numberOfTheaters/2)
        
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        theaterMapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        
        // "A NotificationCenter object (or simply, notification center) provides a
        // mechanism for broadcasting information within a program." [Apple]
        
        // Obtain the object reference of the default notification center
        let notificationCenter = NotificationCenter.default
        
        // Add self as an Observer for the "Keyboard Will Show" notification by specifying
        // the name of the method to invoke upon that notification.
        notificationCenter.addObserver(self,
                                       selector:   #selector(MyTheatersViewController.keyboardWillShow(_:)),    // <-- Call this method upon Keyboard Will SHOW Notification
            name:       NSNotification.Name.UIKeyboardWillShow,
            object:     nil)
        
        mapsHtmlFilePath = Bundle.main.path(forResource: "maps", ofType: "html")
    }
    
    /*
     ------------------------------------
     MARK: - UITextField Delegate Methods
     ------------------------------------
     */
    
    // This method is called when the user taps inside a text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
    
    // This method is called upon the "Keyboard Will Show" notification
    func keyboardWillShow(_ sender: Notification) {
        
        // "userInfo, the user information dictionary stores any additional
        // objects that objects receiving the notification might use." [Apple]
        let info: NSDictionary = (sender as NSNotification).userInfo! as NSDictionary
        
        /*
         Key     = UIKeyboardFrameBeginUserInfoKey
         Value   = an NSValue object containing a CGRect that identifies the start frame of the keyboard in screen coordinates.
         */
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        
        // Obtain the size of the keyboard
        let keyboardSize: CGSize = value.cgRectValue.size
        
        // Create Edge Insets for the view.
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        
        // Set the distance that the content view is inset from the enclosing scroll view.
        scrollView.contentInset = contentInsets
        
        // Set the distance the scroll indicators are inset from the edge of the scroll view.
        scrollView.scrollIndicatorInsets = contentInsets
        //-----------------------------------------------------------------------------------
        // If active text field is hidden by keyboard, scroll the content up so it is visible
        //-----------------------------------------------------------------------------------
        
        // Obtain the frame size of the View
        var selfViewFrameSize: CGRect = self.view.frame
        
        // Subtract the keyboard height from the self's view height
        // and set it as the new height of the self's view
        selfViewFrameSize.size.height -= keyboardSize.height
        
        // Obtain the size of the active UITextField object
        let activeTextFieldRect: CGRect? = activeTextField!.frame
        
        // Obtain the active UITextField object's origin (x, y) coordinate
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        
        
        if (!selfViewFrameSize.contains(activeTextFieldOrigin!)) {
            
            // If active UITextField object's origin is not contained within self's View Frame,
            // then scroll the content up so that the active UITextField object is visible
            
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set the segmented control to show no selection before the view appears
        self.theaterMapTypeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
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

    @IBAction func backgroundTouch(_ sender: UIControl) {
        
        // Deactivate the Address Text Field object and remove the Keyboard
        theatersLocationInput.resignFirstResponder()
    }
    
    @IBAction func searchMovie(_ sender: AnyObject) {
                // Obtain a new string in which all occurrences of space in the address are replaced by +
                let locationEnteredWithNoSpaces = theatersLocationInput.text!.replacingOccurrences(of: " ", with: "+")
        
                googleQuery = "https://www.google.com/#q=movies+near+\(locationEnteredWithNoSpaces)"
        
                dataToPassWeb[0] = googleQuery
                dataToPassWeb[1] = "Movies Playing"
        
                performSegue(withIdentifier: "webViewTheater", sender: self)
    }
    
    @IBAction func setMapType(_ sender: AnyObject) {
        let selectedRowNumber = pickerView.selectedRow(inComponent: 0)
        
        let theaterName = arrayTheaterNames[selectedRowNumber]
        
        let addressTemp: String = applicationDelegate.dict_Theaters[theaterName] as! String
        
        let addressTrimmed = addressTemp.replacingOccurrences(of: " ", with: "+")
        
        switch sender.selectedSegmentIndex {
        case 0: //RoadMap
            googleQuery = mapsHtmlFilePath! + "?place=" + addressTrimmed + "&zoom=16&maptype=ROADMAP"
        case 1: //SatelliteMap
            googleQuery = mapsHtmlFilePath! + "?place=" + addressTrimmed + "&zoom=16&maptype=SATELLITE"
        case 2: //HybridMap
            googleQuery = mapsHtmlFilePath! + "?place=" + addressTrimmed + "&zoom=16&maptype=HYBRID"
        case 3: //TerrainMap
            googleQuery = mapsHtmlFilePath! + "?place=" + addressTrimmed + "&zoom=16&maptype=TERRAIN"
        default:
            return
        }

        dataToPassWeb[0] = googleQuery
        dataToPassWeb[1] = theaterName
        
        performSegue(withIdentifier: "webViewTheater", sender: self)
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
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewTheater" {
            let theaterWebView: TheaterWebViewController = segue.destination as! TheaterWebViewController
            
            theaterWebView.dataObjectPassed = dataToPassWeb
        }
        
        if segue.identifier == "EditTheater" {
            let editTheater: EditTheaterViewController = segue.destination as! EditTheaterViewController
            
            editTheater.theaterSelectedData = dataTheaterToPass
        }
    }
}
