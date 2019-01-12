//
//  Comment.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/8.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation

struct Comment {
    
    let user:User
    let text:String
    let creationDate:Date
    let uid:String
    
    init(user:User,_dictionary:[String:Any]) {
        self.user = user
        self.text = _dictionary["text"] as? String ?? ""
        let dummyDate = _dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: dummyDate)
        self.uid = _dictionary["uid"] as? String ?? ""
    }
    
    
    
    
}
