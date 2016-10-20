//
//  DataService.swift
//  SocialMedia
//
//  Created by yaser on 10/8/16.
//  Copyright © 2016 yaserBahrami. All rights reserved.
//

import Foundation
import Firebase

class DataService{
    static let ds = DataService()
    
    
    private var _REF_BASE = Firebase(url: "https://yaserbahrami-test1.firebaseio.com")
    
    var REF_BASE: Firebase{
        return _REF_BASE!
    }
    
}
