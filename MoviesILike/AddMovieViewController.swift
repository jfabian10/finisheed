//
//  AddMovieViewController.swift
//  MoviesILike
//
//  Created by CS3714 on 11/12/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved. 11/14
//

import UIKit

class AddMovieViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

   // var delegate: AddMovieViewControllerProtocol? //declare protocol
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var movieTitleLabel: UITextField!
    
    @IBOutlet var movieCastLabel: UITextField!
    
    @IBOutlet var youTubeLabel: UITextField!
    
    @IBOutlet var movieRatingLabel: UISegmentedControl!

    
   // var dataToPass = [String]() ///data to pass upstream
    var dataPassed = [String]() ///movie genre
    
    var activeTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///places save button on view
        //let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AddMovieViewController.save(_:)))
        //self.navigationItem.rightBarButtonItem = saveButton
        
        ///adds gesture recognizer to hide keyboard when user taps anywhere on background
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMovieViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //seg control should have no selection when view loads
        self.movieRatingLabel.selectedSegmentIndex = UISegmentedControlNoSegment
    }
    //hides keyboard
    func dismissKeyboard(){
        view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //will only appear on portrait mode
    override func viewDidAppear(_ animated: Bool) {
        let portraitValue = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portraitValue, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    
    //dictates how picker view appears
    override func viewWillAppear(_ animated: Bool) {
        let numOfRowsToShow = dataPassed.count/2
        pickerView.selectRow(numOfRowsToShow, inComponent:0, animated: false)
        }
    
    // UIPickerView Data Source Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       // return applicationDelegate.vtBuildingNames.count
        return dataPassed.count
    }
    
    // UIPickerView Delegate Method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPassed[row]
    }
    
    // This method is invoked when the user taps the Done key on the keyboard
    
    @IBAction func keyboardDone(_ sender: UITextField) {
        // Once the text field is no longer the first responder, the keyboard is removed
                sender.resignFirstResponder()
        }
    
    
}
