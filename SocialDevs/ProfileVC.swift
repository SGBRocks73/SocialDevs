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

    @IBAction func createProfilePressed(_ sender: Any) {
        
        let userName = profileName.text
        let userImg = profileImg.image
        
        if userName == "" || userImg == nil {
            profileBtn.jitter()
            warningLbl.flashingText()
            
        } else {
            
            print("SGB: Created profile")
            let img = profileImg.image
            
            if let userImage = UIImageJPEGRepresentation(img!, 0.2) {
                
                let imgUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                metaData.contentType = "image/jpeg"
                DataService.ds.REF_USER_IMG.child(imgUid).put(userImage, metadata: metaData) { (metaData, error) in
                    if error != nil {
                        print("SGB: Unable to upload profile picture to FIRStorage")
                    } else {
                        print("SGB: Successful upload of profile picture to FIRStorage")
                        //self.performSegue(withIdentifier: "MainFeedVC", sender: nil)
                    }
                }
            }
            
            
        }
    }
   
}
