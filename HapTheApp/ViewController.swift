//
//  ViewController.swift
//  HapTheApp
//
//  Created by Jim Peraino on 2/3/18.
//  Copyright © 2018 James Peraino. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        placeNameLabel.text = textField.text
    }
    
    // MARK: Actions
    
    @IBAction func setDefaultLabelText(_ sender: Any) {
        placeNameLabel.text = "Default Text"
        
    }
    

}

