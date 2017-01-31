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
import SwiftKeychainWrapper
import TwitterKit
import Fabric

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
    
    var profileUserRef: FIRDatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
               if let _ = KeychainWrapper.standard.string(forKey: key_userID) {
        
            
            // add code here to check if user has a profile (can see using snapshot as NSNULL with profile name)
            //perhaps use a guard klet statement with keychain and profile namw
           
            performSegue(withIdentifier: "MainFeedVC", sender: nil)
            print("SGB: Succesful find of keychain UID")

        }
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
    
    @IBAction func twitterBtnPressed(_ sender: Any) {
        
        Twitter.sharedInstance().logIn(withMethods: .webBased) { (session, error) in
            if session !=  nil {
                print("SGB: Logged in session with \(session?.userName)")
                guard let token = session?.authToken else { return }
                guard let secret = session?.authTokenSecret else { return }
                let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
                self.firebaseAuth(credentials)
            } else {
                print("SGB: Error with Twitter login \(error?.localizedDescription)")
            }
        }
    }
    

    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let pword = passwordTextField.text
        
        if email == "" || pword == "" {
            
        warningLbl.flashingText()
        loginBtn.jitter()
            
        } else {
           
            FIRAuth.auth()?.signIn(withEmail: email!, password: pword!, completion: { (user, error) in
                if error == nil {
                    print("SGB: User successful login on Firebase with email")
                    if let user = user {
                        let userDataSignIn = ["provider": user.providerID]
                        self.finishSignIn(id: user.uid, userData: userDataSignIn)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email!, password: pword!, completion: { (user, error) in
                        if error != nil {
                            print("SGB: Unable to auth with Firebase using email")
                        } else {
                            print("SGB: New user login to Firebase with email GTG")
                            if let user = user {
                                let userDataSignIn = ["provider": user.providerID]
                                self.finishSignIn(id: user.uid, userData: userDataSignIn)
                            }
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
                if let user = user {
                    let userDataSignIn = ["provider": credential.provider]
                    self.finishSignIn(id: user.uid, userData: userDataSignIn)
                }
            }
        })
    }
    
    func finishSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: key_userID)
        profileUserRef = DataService.ds.REF_USERS_CURRENT.child("userData")
        profileUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull  {
                self.performSegue(withIdentifier: "ProfileVC", sender: nil)
            } else {
                self.performSegue(withIdentifier: "MainFeedVC", sender: nil)
            }
        })
        print("SGB: Data saved to keychain")
    }
    
}

