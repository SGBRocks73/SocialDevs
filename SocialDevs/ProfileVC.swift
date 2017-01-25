//
//  ProfileVC.swift
//  SocialDevs
//
//  Created by Steve Baker on 24/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit
import Firebase

class profileBtn: UIButton, Jitterable {
}

class ProfileVC: UIViewController {

    @IBOutlet weak var profileName: dataEntryText!
    @IBOutlet weak var profileImg: CircleImage!
    @IBOutlet weak var profileBtn: profileBtn!
    @IBOutlet weak var warningLbl: warningLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func uploadProfileName(userIDName: String) {
        let profileIDName: Dictionary<String, AnyObject> = ["userName": profileName.text as AnyObject]
        let ProfileNameRef = DataService.ds.REF_USERS_CURRENT.child("\(key_userID)")
        ProfileNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                print("SGB: I'm lost")
                ProfileNameRef.setValue(profileIDName)
            } else {
                print("SGB: Unable to assign profile name correctly")
                ProfileNameRef.setValue(profileIDName)
            }
        })
    }

    @IBAction func createProfilePressed(_ sender: Any) {
        
        let userName = profileName.text
        let userImg = profileImg.image
        
        if userName == "" || userImg == nil {
            //fix userImg nil statement
            profileBtn.jitter()
            warningLbl.flashingText()
            
        } else {
            
            print("SGB: Created profile")
            let img = profileImg.image
        
            if let userImage = UIImageJPEGRepresentation(img!, 0.2) {
                
                let imgUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                uploadProfileName(userIDName: userName!)
                metaData.contentType = "image/jpeg"
                DataService.ds.REF_USER_IMG.child(imgUid).put(userImage, metadata: metaData) { (metaData, error) in
                    if error != nil {
                        print("SGB: Unable to upload profile picture to FIRStorage")
                    } else {
                        print("SGB: Successful upload of profile picture to FIRStorage")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            
        }
    }
   
}
