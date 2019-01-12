//
//  User.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/30.
//  Copyright © 2018 洪森達. All rights reserved.
//

import Foundation
import Firebase
class User {
    
    let userName:String?
    let uid:String?
    let profileImgString:String?
    
    init(_dictionary:[String:Any]) {
        self.userName = _dictionary["userName"] as? String ?? ""
        self.uid = _dictionary["uid"] as? String ?? ""
        self.profileImgString = _dictionary["Profile_image"] as? String ?? ""
    }
    
 
    
}
