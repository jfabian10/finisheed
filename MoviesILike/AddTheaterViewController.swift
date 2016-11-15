//
//  AddTheaterViewController.swift
//  MoviesILike
//
//  Created by Luis Villavicencio  on 11/14/16.
//  Copyright © 2016 Jesus Fabian. All rights reserved.
//

import UIKit

protocol AddTheaterViewControllerProtocol {
    func addTheaterViewController(_ controller: AddTheaterViewController, didFinishWithSave save: Bool)
}

class AddTheaterViewController: UIViewController {
    
    var delegate: AddTheaterViewControllerProtocol?

    @IBOutlet var theaterNameTextField: UITextField!
    
    @IBOutlet var theaterAddressTextField: UITextField!
    
    var saveButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Theater"
        
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AddTheaterViewController.save(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
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
    
    @IBAction func buttonTapped(saveButton sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToTheaters", sender: self)
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
    
    func save(_ sender: AnyObject) {
        delegate?.addTheaterViewController(self, didFinishWithSave: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
