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

class MainFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        //add more code here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as UITableViewCell
    }
    
    
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: key_userID)
        print("SGB: Removed keychain ID \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    
    }

}
