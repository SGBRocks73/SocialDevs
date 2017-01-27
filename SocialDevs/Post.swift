//
//  Post.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    private var _caption: String!
    private var _postKey: String!
    private var _userKey: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _userIDName: String!
    private var _postRef: FIRDatabaseReference!
    private var _userPostRef: FIRDatabaseReference!
    private var _userRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var postKey: String {
        return _postKey
    }
    
    var userKey: String {
        return _userKey
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var userIDName: String {
        if _userIDName == nil {
            _userIDName = "Loading User Name..."
        }
        return _userIDName
    }
        
    
    
    var userRef: FIRDatabaseReference {
        return _userRef
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>, userKey: String) {
        self._postKey = postKey
        self._userKey = userKey
        
        /*if let statement allows for may not be data there or of problem doesnt crash - eg: if missepll caption. This init looks for "tags" in Firebase DB*/
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageURL"] as? String {
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
     
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikesTotal(add_like: Bool) {
        if add_like {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
    func addUserName(userIDKeyRef: FIRDatabaseReference) {
        let userIDKey = userIDKeyRef.key
        let userRef = DataService.ds.REF_USERS.child(userIDKey).child("userName")
        userRef.observe(.value, with: { (snapshot) in
            if let userIDName = snapshot.value as? String {
                self._userIDName = userIDName
            }
            
        })
    }
      
}
