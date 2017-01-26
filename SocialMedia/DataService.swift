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
    private var _ImageShack_API_URL = "https://post.imageshack.us/upload_api.php"
    private var _ImageShack_API_KEY = "Z4BEN9YI4a24cf7df738490d7a0941ba563e3e54"
    var REF_BASE: Firebase{
        return _REF_BASE!
    }
    var REF_POSTS: Firebase{
        return _REF_POSTS!
    }
    var REF_USERS: Firebase{
        return _REF_USERS!
    }
    var ImageShack_API_URL: String{
        return _ImageShack_API_URL
    }
    var ImageShack_API_KEY: String{
        return _ImageShack_API_KEY
    }
    
    var REF_USER_CURRENT: Firebase{
        let uid = UserDefaults.standard.value(forKey: KEY_UID) as! String
        
        let user = Firebase(url: "\(URL_BASE)").child(byAppendingPath: "Users").child(byAppendingPath: uid)
        
        return user!
    }
    
    func CreateFireBaseUser(uid: String, user: Dictionary <String, String> ){
        REF_USERS.child(byAppendingPath: uid).setValue(user)
    }
    
    
    
    
    
    
    
}
