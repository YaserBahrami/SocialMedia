//
//  Post.swift
//  SocialMedia
//
//  Created by yaser on 10/22/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _userName: String!
    private var _postKey: String!
    private var _postRef: Firebase!
    
    var postDescription: String {
        return _postDescription
    }
    var imageUrl: String? {
        return _imageUrl
    }
    var likes: Int{
        return _likes
    }
    var userName: String{
        return _userName
    }
    
    var postKey: String{
        return _postKey
    }

    init(description: String, imageUrl: String?, userName: String) {
        
        self._postDescription = description
        self._imageUrl = imageUrl
        self._userName = userName
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["Likes"] as? Int{
            self._likes = likes
        }
        
        if let imageUrl = dictionary["ImageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        if let desc =  dictionary["Description"] as? String{
            self._postDescription = desc
        }
        if let userName =  dictionary["UserName"] as? String{
            self._userName = userName
        }
        if let userName =  dictionary["UserName"] as? String{
            self._userName = userName
        }
        self._postRef = DataService.ds.REF_POSTS.child(byAppendingPath: self._postKey!)
    }
    
    func adjustLikes(addLike : Bool)
    {
        if addLike{
            _likes = _likes + 1
        }
        else{
            _likes = _likes - 1
        }
        _postRef.child(byAppendingPath: "Likes").setValue(_likes)
    }
    
    
    
    
}
