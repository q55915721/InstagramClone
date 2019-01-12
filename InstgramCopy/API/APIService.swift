//
//  APIService.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/30.
//  Copyright © 2018 洪森達. All rights reserved.
//

import Foundation
import Firebase


class APIService {
    
    
    static let shard = APIService()
    
    func signInWith(email:String,passwords:String ,completion:@escaping(_ error:Error?)->()){
        Auth.auth().signIn(withEmail: email, password: passwords) { (firuser, error) in
            if let err = error {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    
    func registerUser(_email:String,_passwords:String,userName:String,image:UIImage,completion:@escaping(_ error:Error?)->()){
        
        Auth.auth().createUser(withEmail: _email, password: _passwords) { (firUser, error) in
          
            if let err = error {
                print(err.localizedDescription)
                completion(err)
                return
            }
            
            self.uploadImg(img: image, completion: { (error, urlstring) in
                if let error = error {
                    completion(error)
                    return
                }
                guard let uid = firUser?.user.uid else {return}
                guard let profileUrl = urlstring else {return}
                guard let FcmToken = Messaging.messaging().fcmToken else {return}
                let date = ["uid":uid,"email":_email,"userName":userName,"Profile_image":profileUrl,"fcmToken":FcmToken]
                self.updateUserInfo(uid: uid, data: date, completion: completion)
                
            })
            
        }
    }
    
    func uploadImg(img:UIImage,completion:@escaping (_ error:Error?,_ urlString:String?)->()){
        
        guard let imgDate = img.jpegData(compressionQuality: 0.7) else {return}
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference().child("Profile_img").child(fileName)
        ref.putData(imgDate, metadata: nil) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error,nil)
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let error = error {
                    completion(error,nil)
                }
                guard let string = url?.absoluteString else {return}
                completion(nil,string)
            })
            
        }
    }
    
    func updateUserInfo(uid:String,data:[String:Any],completion:@escaping(_ error:Error?)->()){
        
        Database.database().reference().child("Users").child(uid).updateChildValues(data) { (error, drf) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
            
        }
        
    }
    
    func updatePostFromUser(image:UIImage,text:String,completion:@escaping(_ error:Error?)->()){
        
        
        uploadImg(img: image) { (error, imageUrl) in
            
            if let error = error {
                completion(error)
                return
            }
            guard let imageUrlString = imageUrl else {return}
            let width = image.size.width
            let height = image.size.height
            let today = Date().timeIntervalSince1970
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let data = ["ImgUrl":imageUrlString,"imageWidth":width,"imageHeight":height,"postDate":today,"text":text] as [String : Any]
            
            let userRef = Database.database().reference().child("Posts").child(uid)
            userRef.childByAutoId().updateChildValues(data, withCompletionBlock: { (error, rf) in
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            })
        }
        
    }
    
    
    func fetchPosts(user:User,completion:@escaping(_ error:Error? ,_ posts:[Post])->()){
        
        var posts = [Post]()
        guard let uid = user.uid else {return}
        let ref = Database.database().reference().child("Posts").child(uid)
        ref.queryOrdered(byChild: "postDate").observe(.childAdded) { (snap) in
            guard let dic = snap.value as? [String:Any] else {return}
            let post = Post(user: user, _dictionary: dic)
            posts.insert(post, at: 0)
            completion(nil,posts)
        }
    
    }
    
    func fetchPostsForHomeFeed(user:User,completion:@escaping(_ error:Error? ,_ posts:[Post])->()){
        
        var posts = [Post]()
        guard let uid = user.uid else {return}
        let ref = Database.database().reference().child("Posts").child(uid)
        ref.observeSingleEvent(of: .value) { (snap) in
            
            guard let dic = snap.value as? [String:Any] else {return}
            dic.forEach({ (key,value) in
                guard let dictionaris = value as? [String:Any] else {return}
                let post = Post(user: user, _dictionary: dictionaris)
                posts.append(post)
            })
        }
        
    }
    
    func fetchUserFromUid(uid:String,comletion:@escaping (_ user:User?)->()){
        
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String:Any] else {return}
            let user = User(_dictionary: data)
            comletion(user)
        }
    }
    
    func fetchUsersFromDatabase(completion:@escaping (_ Users:[User])->()){
        
        var users = [User]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Users").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dic = snapshot.value as? [String:Any] else {return}
            dic.forEach({ (key,value) in
                if key == uid {
                    return
                }
                guard let userDic = value as? [String:Any] else {return}
                let user = User(_dictionary: userDic)
                users.append(user)
                completion(users)
            })
        }
    }
    
    func tofollowUser(currentUid:String,followeID:String,completion: @escaping (_ error:Error?)->()){
        
        Database.database().reference().child("Follows").child(currentUid).updateChildValues([followeID:1] as [String:Any]) { (error, ref) in
            
            if let err = error {
                completion(err)
                return
            }
        }
    }
    
    func followORUnFollow(currentUid:String,followeID:String,completion: @escaping (_ ifFollow:Bool)->()){
        
        Database.database().reference().child("Follows").child(currentUid).child(followeID).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists() {
                completion(true)
            }else{
                completion(false)
            }
            
        }
    }
    
    func toUnFollow(currentUid:String,followeID:String,completion: @escaping (_ error:Error?)->()){
        
        Database.database().reference().child("Follows").child(currentUid).child(followeID).removeValue { (errpr, _) in
            if let err = errpr {
                completion(err)
                return
            }
        }
        
        
    }
    
    
    func uploadToComments(value:[String:Any],post:Post,completion:@escaping(_ error:Error?)->()){
        guard let postid = post.postId else {return}
        let ref = Database.database().reference().child("Comments").child(postid)
        ref.childByAutoId().updateChildValues(value) { (error, _) in
            if let err = error {
                completion(err)
                return
            }
        }
    }
    
    
}//end of the class.

