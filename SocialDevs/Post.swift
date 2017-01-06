//
//  Post.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import Foundation


class Post {
    
    private var _caption: String!
    private var _postKey: String!
    private var _imageUrl: String!
    private var _likes: Int!
    
    var caption: String {
        return _caption
    }
    
    var postKey: String {
        return _postKey
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        /*if let statement allows for may not be data there or of problem doesnt crash - eg: if missepll caption. This init looks for "tags" in Firebase DB*/
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
    }
    
    
}
