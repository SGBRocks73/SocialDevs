//
//  LoginVC.swift
//  SocialDevs
//
//  Created by Steve Baker on 3/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit

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
    
   

    @IBAction func loginBtnPressed(_ sender: UIButton) {

        warningLbl.flasingText()
        loginBtn.jitter()
    
        
    }
    
}

