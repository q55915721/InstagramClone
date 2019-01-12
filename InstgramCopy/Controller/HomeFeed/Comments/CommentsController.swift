//
//  CommentsController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/7.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController,UICollectionViewDelegateFlowLayout,CommentInputAccessoryViewDelegate {

    
    
    var post:Post!{
        didSet{
        
            downloadComments()
        }
    }
    
    fileprivate func downloadComments() {
        guard let postId = post.postId else {return}
        Database.database().reference().child("Comments").child(postId).observe(.childAdded) { (snapshot) in
            guard let snap = snapshot.value as? [String:Any] else {return}
              
                guard let uid = snap["uid"] as? String else {return}
                APIService.shard.fetchUserFromUid(uid: uid, comletion: { (user) in
                    guard let user = user else {return}
                    let comment = Comment(user: user, _dictionary: snap)
                    self.comments.append(comment)
             
                        self.collectionView.reloadData()
                    
                })
            
        }
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       
    }
    
   fileprivate let cellId = "cellid"
    
    fileprivate func setupCollectionView(){
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    

    
    lazy var  ContainerVIewForAccessory:CommentInputAccessoryView = {
        let containerVIew = CommentInputAccessoryView()
            containerVIew.delegate = self
        return containerVIew

    }()
    
    
    func didSubmit(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let value = ["text":comment,"creationDate":Date().timeIntervalSince1970,"uid":uid] as [String : Any]
        
        APIService.shard.uploadToComments(value: value, post: post) { (error) in
            if let err = error {
                print(err)
                return
            }
        }
           self.ContainerVIewForAccessory.clearCommentTextField()
    }

    override var inputAccessoryView: UIView?{
        get{
            return ContainerVIewForAccessory
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK:-collectionView Cell
    
    var comments = [Comment]()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
            cell.comment = comments[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let initFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: initFrame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimateSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(40 + 8 + 8, estimateSize.height)
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    
    
}
