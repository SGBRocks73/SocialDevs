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

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var profileName: dataEntryText!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileBtn: profileBtn!
    @IBOutlet weak var warningLbl: warningLabel!
    
    var imagePicker: UIImagePickerController!
    var profileImgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        

    }
    
    func uploadProfileName(userName: String) {
        let profileIDName: Dictionary<String, AnyObject> = ["userName": profileName.text as AnyObject]
        let ProfileNameRef = DataService.ds.REF_USERS_CURRENT.child("userData")
        ProfileNameRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print("SGB: Assigned profile name correctly")
                ProfileNameRef.updateChildValues(profileIDName)
        })
    }
    
    func uploadProfileURL(imageURL: String) {
        let profileURL: Dictionary<String, AnyObject> = ["profilePicURL": imageURL as AnyObject]
        let profileRef = DataService.ds.REF_USERS_CURRENT.child("userData")
        profileRef.updateChildValues(profileURL)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let profileImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImg.image = profileImage
            profileImgSelected = true
        } else {
            print("SGB: No valid profile image selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profleBtnTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func createProfilePressed(_ sender: Any) {
        
        let userName = profileName.text
        // use guard let where text == ""
        let userImg = profileImg.image
        if userName == "" || userImg == UIImage(named: "blue-user-head-png-18") {
            //fix userImg nil statement
            profileBtn.jitter()
            warningLbl.flashingText()
        } else if profileImgSelected == true {
            print("SGB: Created profile")
            if let userImage = UIImageJPEGRepresentation(userImg!, 0.2) {
                let imgUid = NSUUID().uuidString
                let metaData = FIRStorageMetadata()
                uploadProfileName(userName: userName!)
                metaData.contentType = "image/jpeg"
                DataService.ds.REF_USER_IMG.child(imgUid).put(userImage, metadata: metaData) { (metaData, error) in
                    if error != nil {
                        print("SGB: Unable to upload profile picture to FIRStorage")
                    } else {
                        print("SGB: Successful upload of profile picture to FIRStorage")
                        let downloadURL = metaData?.downloadURL()?.absoluteString
                        self.uploadProfileURL(imageURL: downloadURL!)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            profileName.text = ""
            profileImg.image = UIImage(named: "blue-user-head-png-18")
            profileImgSelected = false
            
        }
    }
    
}
