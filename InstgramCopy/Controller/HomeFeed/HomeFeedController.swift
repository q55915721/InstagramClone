//
//  HomeFeedController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/3.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import Firebase

class HomeFeedController:UICollectionViewController,UICollectionViewDelegateFlowLayout,HomeFeedCellDelegate{
 
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        collectionView.backgroundColor = .white
        setupRegisterCell()
        fetchAllPosts()
        setupRefreshController()
        observerNotitfication()
       
    }
    
    fileprivate func observerNotitfication(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: SharadPhotoController.notificationNameForRefresh, object: nil)
        
        
    }
    
    fileprivate func setupRefreshController(){
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresh
    }
    
 
    @objc func handleRefresh(){
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func setupNavigationBar(){
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
          navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
    }
    @objc fileprivate func handleCamera(){
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    fileprivate let cellId = "cellId"
    
    fileprivate func setupRegisterCell(){
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func fetchAllPosts(){
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("Follows").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ key, value in
                APIService.shard.fetchUserFromUid(uid: key, comletion: { (user) in
                    guard let user = user else {return}
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
    }

    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        APIService.shard.fetchUserFromUid(uid: uid) { (user) in
            guard let user = user else {return}
            self.fetchPostsWithUser(user: user)
        }
        
    }
    fileprivate func fetchPostsWithUser(user: User) {
        guard let useriD = user.uid else {return}
        let ref = Database.database().reference().child("Posts").child(useriD)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                
                var post = Post(user: user, _dictionary: dictionary)
                    post.postId = key
          
        Database.database().reference().child("Like").child(key).child(uid).observeSingleEvent(of: .value, with: { (snap) in
            
            
                if let value = snap.value as? Int , value == 1 {
                     post.hasLiked = true
                 }else{
                    post.hasLiked = false
                  }
        
                    self.posts.append(post)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    
                    self.collectionView?.reloadData()
                    
                })
 
            })
            
  
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeFeedCell
    if indexPath.item < posts.count { cell.post = posts[indexPath.item] }
//        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    //MARK:DelegateFormHomeCell
    func didTapComments(Post: Post) {
        
        let commentsController = CommentsController(collectionViewLayout:UICollectionViewFlowLayout())
            commentsController.post = Post
        navigationController?.pushViewController(commentsController, animated: true)
        
    }
    
    func didLike(for cell: HomeFeedCell) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let indexpath = collectionView.indexPath(for: cell) else {return}

        var post = self.posts[indexpath.item]
             post.hasLiked = !post.hasLiked
        let value = [uid:post.hasLiked == true ? 1 : 0]
       
        guard let postID = post.postId else {return}
        Database.database().reference().child("Like").child(postID).updateChildValues(value) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
                self.posts[indexpath.item] = post
             print(post.hasLiked)
                self.collectionView.reloadItems(at: [indexpath])
            
          
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
    
    
    
}
