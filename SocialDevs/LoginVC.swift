//
//  LoginVC.swift
//  SocialDevs
//
//  Created by Steve Baker on 3/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import Firebase

class dataEntryText: UITextField, Jitterable, Flashable {
}

class loginButton: UIButton, Jitterable, Flashable {
}

class warningLabel: UILabel, Jitterable, Flashable {
}

class LoginVC: UIViewController {
    

    @IBOutlet weak var emailTextField: dataEntryText!
    @IBOutlet weak var passwordTextField: dataEntryText!
    @IBOutlet weak var warningLbl: warningLabel!
    @IBOutlet weak var loginBtn: loginButton!
    @IBOutlet weak var twitterBtn: RoundedButton!
    @IBOutlet weak var facebookBtn: RoundedButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    @IBAction func facbeookBtnPressed(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("SGB: Unable to auth with FB with \(error)")
            } else if result?.isCancelled == true {
                print("SGB: User cancelled FB login auth")
            } else {
                print("SGB: successful FB auth")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
            
        }
    }

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let pword = passwordTextField.text
        
        if email == "" || pword == "" {
            
        warningLbl.flasingText()
        loginBtn.jitter()
            
        } else {
           
            FIRAuth.auth()?.signIn(withEmail: email!, password: pword!, completion: { (user, error) in
                if error == nil {
                    print("SGB: User successful login on Firebase with email")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email!, password: pword!, completion: { (user, error) in
                        if error != nil {
                            print("SGB: Unable to auth with Firebase using email")
                        } else {
                            print("SGB: New user login to Firebase with email GTG")
                        }
                        
                    })
                }
            })
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("SGB: Unable to auth with Firebase login with \(error)")
            } else {
                print("SGB: Successful auth with Firebase")
            }
        })
    }
    
}

