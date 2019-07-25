//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {

        SVProgressHUD.show()    //Loading indicator as soon as the log in button is pressed
        
        //TODO: Log in the user
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!)
        {
            (user, error) in
            
            if error != nil
            {
                print(error!)
            }
            else
            {
                print("LogIn Successful")
                
                SVProgressHUD.dismiss() //After login successful, dismissing loading indicator
                
                self.performSegue(withIdentifier: "goToChat", sender: self)     //Using self dot because we are calling a function inside a closure
            }
        }
        
    }
    


    
}  
