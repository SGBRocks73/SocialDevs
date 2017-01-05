//
//  MainFeedVC.swift
//  SocialDevs
//
//  Created by Steve Baker on 5/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class MainFeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutBtnPressed(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: key_userID)
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
}
