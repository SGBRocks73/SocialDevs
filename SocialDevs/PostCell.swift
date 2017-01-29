//
//  PostCell.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var heartBig: UIImageView!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    var profilePicRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let heartTap = UITapGestureRecognizer(target: self, action: #selector(heartTapped))
        heartTap.numberOfTapsRequired = 1
        heartBig.addGestureRecognizer(heartTap)
        heartBig.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil, pImage: UIImage? = nil) {
        
        //userIDRef = DataService.ds.REF_POSTS.child(post.postKey).child("usersKey").child(post.userKey)
        
        self.post = post
        likesRef = DataService.ds.REF_USERS_CURRENT.child("likes").child(post.postKey)
        self.captionText.text = post.caption
        self.likesLbl.text = String(post.likes)
        self.userName.text? = post.userIDName.capitalized
        
        if pImage != nil {
            self.profileImg.image = pImage
        } else {
            let profileImageRef = FIRStorage.storage().reference(forURL: post.profilePicURL)
            profileImageRef.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("SGB Unable to download profile image \(error?.localizedDescription)")
                } else {
                    if let profileImage = data {
                        if let pImage = UIImage(data: profileImage) {
                            self.profileImg.image = pImage
                            MainFeedVC.imageCache.setObject(pImage, forKey: post.profilePicURL as NSString)
                        }
                        
                    }
                }
            })
        }
        
        
        if img != nil {
            self.postPhoto.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 4 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("SGB: Unable to download image from FIR Storage \(error)")
                } else {
                    print("SGB: Image downloaded from FIR Storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postPhoto.image = img
                            MainFeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.heartBig.image = UIImage(named: "empty-heart")
            } else {
                self.heartBig.image = UIImage(named: "filled-heart")
            }
        })
        
        self.userName.text = post.userIDName.capitalized
        //add code here to download profile picture by using user id key within post
    }
    
    func heartTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.heartBig.image = UIImage(named: "filled-heart")
                self.post.adjustLikesTotal(add_like: true)
                self.likesRef.setValue(true)
            } else {
                self.heartBig.image = UIImage(named: "empty-heart")
                self.post.adjustLikesTotal(add_like: false)
                self.likesRef.removeValue()
            }
        })
    }
    

}
