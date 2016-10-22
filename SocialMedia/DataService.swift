//
//  DataService.swift
//  SocialMedia
//
//  Created by yaser on 10/8/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://yaserbahrami-test1.firebaseio.com"

class DataService{
    static let ds = DataService()
    
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/Posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/Users")

    
    var REF_BASE: Firebase{
        return _REF_BASE!
    }
    var REF_POSTS: Firebase{
        return _REF_POSTS!
    }
    var REF_USERS: Firebase{
        return _REF_USERS!
    }
    
    
    func CreateFireBaseUser(uid: String, user: Dictionary <String, String> ){
        REF_USERS.child(byAppendingPath: uid).setValue(user)
    }
    
    
    
    
    
    
    
}
