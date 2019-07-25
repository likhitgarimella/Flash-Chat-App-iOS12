//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()    //Loading indicator as soon as the register button is pressed
        
        //TODO: Set up a new user on our Firbase database
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user, error) in
            if error != nil
            {
                print(error!)
            }
            else
                {
                    //success
                    print("Registration Successful!")
                    
                    SVProgressHUD.dismiss() //After registering is successful, dismissing loading indicator
                    
                    self.performSegue(withIdentifier: "goToChat", sender: self) //Using self dot because we are calling a function inside a closure
                }
            }
        }
        

        
        
    } 
    
    

