//
//  SignUpVC.swift
//  aNSWR
//
//  Created by Hui Jun on 1/31/17.
//  Copyright © 2017 aNSWR. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {

    private let NEWS_FEED_SEGUE_ID = "NewsFeedVC"

    @IBOutlet weak var EmailText: CustomTextField!
    
    @IBOutlet weak var UsernameText: CustomTextField!
    
    @IBOutlet weak var PasswordText: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.instance.isLoggedIn() {
            performSegue(withIdentifier: NEWS_FEED_SEGUE_ID, sender: nil)
        }
    }
    
    @IBAction func BackButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func SignUpButton(_ sender: AnyObject) {
        if EmailText.text != "" && isValidEmail(testStr: EmailText.text!) && PasswordText.text != "" && UsernameText.text != "" {
            
            AuthProvider.instance.signUp(withEmail: EmailText.text!, username: UsernameText.text!, password: PasswordText.text!, loginHandler: { (message) in
                if message != nil {
                    self.showAlertMessage(title: "Problem With Signing Up", message: message!);
                } else {
                    self.EmailText.text = ""
                    self.UsernameText.text = ""
                    self.PasswordText.text = ""
                    self.performSegue(withIdentifier: self.NEWS_FEED_SEGUE_ID, sender: nil)
                }
                
            });
            
        } else {
            showAlertMessage(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }

    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    private func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil);
        alert.addAction(ok);
        self.present(alert, animated: true, completion: nil);
    }


}
