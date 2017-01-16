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
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value!)
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post.init(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let postData = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = MainFeedVC.imageCache.object(forKey: postData.imageUrl as NSString) {
                cell.configureCell(post: postData, img: img)
                return cell
            } else {
                cell.configureCell(post: postData)
                return cell
            }
            
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
                    
                }
            }
        }
    }
    
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: key_userID)
        print("SGB: Removed keychain ID \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    
    }

}
