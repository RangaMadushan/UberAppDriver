//
//  signInVC.swift
//  Uber App For Driver
//
//  Created by Ranga Madushan on 3/17/18.
//  Copyright © 2018 Ranga Madushan. All rights reserved.
//

import UIKit
import FirebaseAuth

class signInVC: UIViewController {
    
    private let DRIVER_SEGUE = "DriverVC"
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logIn(_ sender: AnyObject) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
          
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                } else {
                
             self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                }
                
            })
        
        } else {
            alertTheUser(title: "Email And Password Are Required", message: "Please enter the email and password in the text fields")
        }
        
    } //func login
    
    @IBAction func signUp(_ sender: AnyObject) {
        
        if emailTextField.text! != "" && passwordTextField.text! != "" {
            
            AuthProvider.Instance.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New User", message: message!)
                } else {
                
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                }
            })
            
        }else{
            alertTheUser(title: "Email And Password Are Required", message: "Please enter the email and password in the text fields")
        }
        
    } // func sign up
    
    
    
    private func alertTheUser(title: String, message: String) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    } //func alert user

}//class

























