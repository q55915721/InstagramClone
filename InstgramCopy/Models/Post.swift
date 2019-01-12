//
//  Post.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/2.
//  Copyright © 2019 洪森達. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    
    let imageUrl:String
    let creationDate:Date
    let text:String
    let width:CGFloat
    let height:CGFloat
    let user:User
    var postId:String?
    var hasLiked:Bool = false
    
    init(user:User,_dictionary:[String:Any]){
        
        self.user = user
        self.imageUrl = _dictionary["ImgUrl"] as? String ?? ""
        let dateFrom1970 = _dictionary["postDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: dateFrom1970)
        self.text = _dictionary["text"] as?String  ?? ""
        self.width = _dictionary["width"] as? CGFloat ?? 0
        self.height = _dictionary["height"] as? CGFloat ?? 0

    }
    
    
    
    
    
    
}
