//
//  Post.swift
//  SocialMedia
//
//  Created by yaser on 10/22/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import Foundation

class Post{
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _userName: String!
    private var _postKey: String!
    
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
    }
    
    
    
    
}
