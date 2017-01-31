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

class MainFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImage: CircleImage!
    @IBOutlet weak var captionField: TextFieldExtras!
    
    var posts = [Post]()

    var userName: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var userIDKey: FIRDatabaseReference!

    
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
       
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SGB: \(snapshot)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let Pkey = snap.key

                        let insidePostRef = DataService.ds.REF_POSTS.child(Pkey).child("usersKey")
                        insidePostRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                for minisnap in snaps {
                                    

                                    let userKey = minisnap.key
                                    
                                    print("SGB: User key in post \(Pkey) is \(userKey)")
                                    
                                    let userProfileRef = DataService.ds.REF_USERS.child(userKey)
                                    userProfileRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                        if let data = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                            for microsnap in data {
                                                 if let userProflie = microsnap.value as? Dictionary<String, AnyObject> {
                                                    if microsnap.key == "userData" {
                                                        
                                                        let post = Post.init(postKey: Pkey, postData: postDict, userKey: userKey, userProfileData: userProflie)
                                                        
                                                        self.posts.append(post)

                                                            print("SGB this is the user profile data \(userProflie)")
                                                    }
                                                }
                                            }
                                            self.tableView.reloadData()
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
                
                self.tableView.reloadData()
            }
        })
        

    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            let postData = posts[indexPath.row]
            if let img = MainFeedVC.imageCache.object(forKey: postData.imageUrl as NSString), let pImage = MainFeedVC.imageCache.object(forKey: postData.profilePicURL as NSString) {
                cell.configureCell(post: postData, img: img, pImage: pImage)
            } else {
                cell.configureCell(post: postData)
            }
            return cell
        } else {
        return UITableViewCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imageSelected = true
        } else {
            print("SGB: No valid image added")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func imagePickerPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
  
    @IBAction func postBtnPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            //using the guard statement - if it is NOT true do the code
            print("SGB: Caption must be enetered")
            return
        }
        guard let img = addImage.image, imageSelected == true else {
            print("SGB: Image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POSTS_IMG.child(imgUid).put(imgData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("SGB: Unable to upload image to FIR Storage")
                } else {
                    print("SGB: Successful uplaod image to FIR Storage")
                    let downloadUrl = metaData?.downloadURL()?.absoluteString
                    self.uploadToFirebase(imageUrl: downloadUrl!)
                    
                }
            }
        }
    }
    
    func uploadToFirebase(imageUrl: String) {

        let post : Dictionary<String, AnyObject> = [
            "caption": captionField.text as AnyObject,
            "imageURL": imageUrl as AnyObject,
            "likes": 0 as AnyObject,
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        captionField.text = ""
        imageSelected = false
        addImage.image = UIImage(named: "add-image")
       
        if let uid = KeychainWrapper.standard.string(forKey: key_userID) {
            let postUser: Dictionary<String, AnyObject> = [uid: true as AnyObject]
            firebasePost.child("usersKey").updateChildValues(postUser)
        }

        self.tableView.reloadData()
        
    }
    
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: key_userID)
        print("SGB: Removed keychain ID \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    
    }

}
