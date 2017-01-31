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
    private var _ProfilePicURL: String!
    private var _postRef: FIRDatabaseReference!
    private var _userPostRef: FIRDatabaseReference!
    private var _userRef: FIRDatabaseReference!
    
    var caption: String {
        if _caption == nil {
            _caption = "Loading Caption..."
        }
        return _caption
    }
    
    var postKey: String {
        return _postKey
    }
    
    var userKey: String {
        if _userKey == nil {
            _userKey = ""
        }
        return _userKey
    }
    
    var imageUrl: String {
        if _imageUrl == nil {
            _imageUrl = ""
        }
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var userIDName: String {
        if _userIDName == nil {
            _userIDName = "Loading User..."
        }
        return _userIDName
    }
    var profilePicURL: String {
        if _ProfilePicURL == nil {
            _ProfilePicURL = ""
        }
        return _ProfilePicURL
    }
        
    
    
    var userRef: FIRDatabaseReference {
        return _userRef
    }
    
//    init(caption: String, imageUrl: String, likes: Int) {
//        self._caption = caption
//        self._imageUrl = imageUrl
//        self._likes = likes
//    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>, userKey: String, userProfileData: Dictionary<String, AnyObject>) {
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
        if let userIDName = userProfileData["userName"] as? String {
            self._userIDName = userIDName
        }
        if let profilePicURL = userProfileData["profilePicURL"] as? String {
            self._ProfilePicURL = profilePicURL
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
    
    
}
