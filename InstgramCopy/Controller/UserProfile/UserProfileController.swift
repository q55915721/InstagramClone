//
//  UserProfileController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/30.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class UserProfileController:UICollectionViewController,UICollectionViewDelegateFlowLayout,UserProfileHeaderDelegate{
    
    
    
    var userID:String?
    
    fileprivate let homeCellid = "homecell"
    
    
    fileprivate func setupCell() {
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: homeCellid)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
      
        fetchUser()
        setupCell()
        setupNvButton()
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(handleRefreshing), for: .valueChanged)
        collectionView.refreshControl = refreshController
        observerNotitfication()
    }
    
    fileprivate func observerNotitfication(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshing ), name: SharadPhotoController.notificationNameForRefresh, object: nil)
        
        
    }
    
    @objc fileprivate func handleRefreshing(){
        posts.removeAll()
        isFinishPaginate = false
        fetchUser()
    }
    
    var posts = [Post]()
    var isFinishPaginate = false
    
    fileprivate func fetchPagination(){
        guard let uid = self.user?.uid else {return}
        guard let user = self.user else {return}
     
        let ref = Database.database().reference().child("Posts").child(uid)
        var query = ref.queryOrdered(byChild: "postDate")
        
        if posts.count > 0 {
            let value = posts.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value) { (snapshot) in
            
            guard var allObject = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            allObject.reverse()
            
            if allObject.count < 4 {
                self.isFinishPaginate = true
            }
            
            if self.posts.count > 0 && allObject.count > 0 {
                allObject.removeFirst()
            }
            
            allObject.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String:Any] else {return}
                
                var post = Post(user: user, _dictionary: dictionary)
                    post.postId = snapshot.key
                self.posts.append(post)
                
            })
            self.posts.forEach({ (p1) in
                print(p1.postId ?? "")
            })
            self.collectionView.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    
    
    
//    fileprivate func fetchPhotos(){
//
//
//        if let userr = user {
//            APIService.shard.fetchPosts(user: userr) { (error, posts) in
//
//                self.posts = posts
//
//                self.collectionView.reloadData()
//
//            }
//        }else{
//            print("nil")
//        }
//
//    }
    
    fileprivate func setupNvButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    @objc fileprivate func handleLogout(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                self.goingToLogin()
            }catch let err {
                print(err.localizedDescription)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    
    }
    
    fileprivate func goingToLogin() {
    
            let login = LoginViewController()
            let nv = UINavigationController(rootViewController: login)
            self.present(nv, animated: true, completion: nil)
        
    }
    var user:User?
    
    fileprivate func fetchUser(){
       
        let hub = JGProgressHUD(style: .dark)
            hub.textLabel.text = "Loading..."
            hub.show(in: self.view)
        let uid = userID ?? Auth.auth().currentUser?.uid ?? ""
        
    Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            hub.dismiss()
            if let data = snapshot.value as? [String:Any] {
                let user = User(_dictionary: data)
                self.user = user
               
                DispatchQueue.main.async {
                    self.navigationItem.title = self.user?.userName
                    self.collectionView.reloadData()
                }
                 self.fetchPagination()
            }
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
       
        cell.delegate = self
        cell.user = user
        
        return cell
    }
    
    var isGrid:Bool = true
    
    func handleGrid() {
        isGrid = true
        collectionView.reloadData()
    }
    
    func handleList() {
       isGrid = false
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
        
    }
    fileprivate let cellID = "cellId"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == posts.count - 1 && !isFinishPaginate {
            fetchPagination()
        }
        
        
        
        if isGrid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserProfileCell
            cell.post = posts[indexPath.item]
            
            return cell
        }else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellid, for: indexPath) as! HomeFeedCell
            cell.post = posts[indexPath.item]
            
            return cell
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGrid {
            
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }else{
            let width = view.frame.width
            var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
            height += view.frame.width
            height += 50
            height += 60
            
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}//end of the class
