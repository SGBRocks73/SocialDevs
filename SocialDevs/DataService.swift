//
//  DataService.swift
//  SocialDevs
//
//  Created by Steve Baker on 6/1/17.
//  Copyright © 2017 Steve Baker. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORE_BASE = FIRStorage.storage().reference()
//Full CAPS common convention for global stuff

class DataService {
    
    static let ds = DataService()
    
    //DB Reference
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage Reference
    private var _REF_POSTS_IMG = STORE_BASE.child("post-pics")
    
    var REF_POSTS: FIRDatabaseReference! {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USERS_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: key_userID)
        let userDBRef = REF_USERS.child(uid!)
        return userDBRef
    }
    
    var REF_POSTS_IMG: FIRStorageReference {
        return _REF_POSTS_IMG
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}
