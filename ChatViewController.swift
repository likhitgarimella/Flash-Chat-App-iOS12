//
//  ViewController.swift
//  Flash Chat
//
//  Created by Likhit Garimella on 24/06/2019.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self  //messageTableView is linked to the Table View
        
        
        //TODO: Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        //We use selectors to determine which method should be called on which object while the app is running
        messageTableView.addGestureRecognizer(tapGesture)
        

        //TODO: Register your MessageCell.xib file here:
        //Step-3
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        retrieveMessages()
        
        messageTableView.separatorStyle = .none     //Disabling the separators between messages
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    //Step-1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Step-2
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String?
        //Messages that we sent
        {
            cell.avatarImageView.backgroundColor = UIColor.flatLime()
            cell.messageBackground.backgroundColor = UIColor.flatPowderBlue()
        }
        else
        //For messgaes that aren't sent
        {
            cell.avatarImageView.backgroundColor = UIColor.flatOrange()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return 3 -> for 3 dummy msgs we had previously
        return messageArray.count
    }
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped()
    {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView()
    {
        messageTableView.rowHeight = UITableView.automaticDimension //Requests the UITableView to use the default value for a given dimension
        //UITableView.automaticDimension is solving the problem of resizing the chat text
        //Now even if the msg is large, bcuz of auto layout the chat text gets resized
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5)
        {
            self.heightConstraint.constant = 308 //On tapping the message text field, the chat screen must become big, text field size(50) + keyboard size(258) = 308
            self.view.layoutIfNeeded()   //This means we are instructing auto layout that if a constraint has changed, or something in the view has changed, redraw the whole thing
            //Inserting self to both, since we are inside a Closure now
        }
        
    }
    
    
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5)
        {
            self.heightConstraint.constant = 50     //Disabling the keypad(258 points)
            self.view.layoutIfNeeded()
            //Though we have written these 2 lines of code, on tapping on view screen, the keyboard doesnt goes off. For that -> tapGesture
        }
        
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        
        messageTextfield.isEnabled = false  //After tapping the send button, clearing the message text field
        sendButton.isEnabled = false    //Disabling the send button, all this bcuz to avoid sending msgs multiple times/ sending duplicate msgs
        
        //TODO: Send the message to Firebase and save it in our database

        let messagesDB = Database.database().reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary)  //Closure
        {
            (error, reference) in
            if error != nil
            {
                print(error!)
            }
            else
            {
                print("Message Saved Successfully!")
                
                //And now we have to enable back, for a new msg
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                
                self.messageTextfield.text = "" //After tapping the sender button, clearing the message text field
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages()
    {
        let messagesDB = Database.database().reference().child("Messages")
        
        messagesDB.observe(.childAdded)   //This means whenever a new entry gets added into the messages database, and this parameter takes a closure
        { (snapshot) in
           
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            print(text, sender)
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()  //Every single time when there is a new msg, reload data
            
        }
    }

    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do
        {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)   //Takes back to Root View Controller by an Animation
        }
        catch
        {
            print("Error!")
        }
        
    }
    


}
