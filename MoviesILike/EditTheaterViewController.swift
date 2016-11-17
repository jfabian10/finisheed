//
//  EditTheaterViewController.swift
//  MoviesILike
//
//  Created by Jesus Fabian on 11/14/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

class EditTheaterViewController: UIViewController {
    
    @IBOutlet var theaterNameTextField: UITextField!
    
    @IBOutlet var theaterAddressTextField: UITextField!
    
    var theaterSelectedData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theaterNameTextField.text! = theaterSelectedData[0]
        theaterAddressTextField.text! = theaterSelectedData[1]
    }

    override func viewDidAppear(_ animated: Bool) {
        /*
         -------------------------------------------------------------------
         Force this view to be displayed only in Portrait device orientation
         -------------------------------------------------------------------
         */
        let portraitValue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(portraitValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    /*
     ---------------------------------
     MARK: - Keyboard Handling Methods
     ---------------------------------
     */
    
    // This method is invoked when the user taps the Done key on the keyboard
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // Once the text field is no longer the first responder, the keyboard is removed
        sender.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if theaterNameTextField.isFirstResponder && (touch.view != theaterNameTextField) {
                theaterNameTextField.resignFirstResponder()
            }
            
            if theaterAddressTextField.isFirstResponder && (touch.view != theaterAddressTextField) {
                theaterAddressTextField.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
