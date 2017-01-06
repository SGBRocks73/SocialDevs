//
//  DataService.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
//Full CAPS common convention for global stuff

class DataService {
    
    static let ds = DataService()
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_POSTS: FIRDatabaseReference! {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}
