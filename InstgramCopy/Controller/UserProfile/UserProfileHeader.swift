//
//  UserProfileHeader.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/30.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func handleGrid()
    func handleList()
}

class UserProfileHeader: UICollectionViewCell {

    
    var delegate:UserProfileHeaderDelegate?
    
    var user:User?{
        didSet{
           
            if let imgUrl = user?.profileImgString {
                profileImgView.setupImageCacheWithURl(imgUrl)
            }
            userNameLabel.text = user?.userName ?? ""
            
            setupButton()
        }
    }
    
    
    fileprivate func setupButton(){
    
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentUserID == userId {
            //edit
        }else{
            
            APIService.shard.followORUnFollow(currentUid: currentUserID, followeID: userId) { (isFollow) in
                if isFollow {
                    self.editOrFollow.setTitle("Unfollow", for: .normal)
                }else{
                    self.followStyle()
                }
            }
           
        }
    }
    
    fileprivate func followStyle(){
        editOrFollow.setTitle("Follow", for: .normal)
        editOrFollow.setTitleColor(.white, for: .normal)
        editOrFollow.layer.borderWidth = 1
        editOrFollow.layer.borderColor = UIColor.init(white:0 , alpha: 0.2).cgColor
        editOrFollow.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    }
    fileprivate func unfollowStyle(){
        editOrFollow.layer.borderColor = UIColor.lightGray.cgColor
        editOrFollow.layer.borderWidth = 1
        editOrFollow.setTitle("Unfollow", for: .normal)
        editOrFollow.setTitleColor(UIColor.black, for: .normal)
        editOrFollow.backgroundColor = .white
        editOrFollow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    let profileImgView:UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.borderWidth = 1
            iv.layer.borderColor = UIColor.black.cgColor
            iv.clipsToBounds = true
        return iv
    }()
    
    lazy var gridButton:UIButton = {
        let img = UIImageView(image: #imageLiteral(resourceName: "grid"))
        let bt = UIButton(type: .system)
            bt.setImage(img.image, for: .normal)
        bt.addTarget(self, action: #selector(handleGrid), for: .touchUpInside)
        return bt
    }()
    
    let mainBlue = UIColor.rgb(red: 149, green: 204, blue: 244)
    
    @objc fileprivate func handleGrid(button:UIButton){
        button.tintColor = mainBlue
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.handleGrid()
    }
    
    lazy var listButton:UIButton = {
        let img = UIImageView(image: #imageLiteral(resourceName: "list"))
        let bt = UIButton(type: .system)
            bt.tintColor = UIColor(white: 0, alpha: 0.2)
        bt.setImage(img.image, for: .normal)
        bt.addTarget(self, action: #selector(handleList), for: .touchUpInside)
        return bt
    }()
    @objc fileprivate func handleList(button:UIButton){
        button.tintColor = mainBlue
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.handleList()
    }
    
    let ribbonButton:UIButton = {
        let img = UIImageView(image: #imageLiteral(resourceName: "ribbon"))
        let bt = UIButton(type: .system)
        bt.tintColor = UIColor(white: 0, alpha: 0.2)
        bt.setImage(img.image, for: .normal)
        return bt
    }()
    
    lazy var postsLabel:UILabel = {
        let lb = UILabel()
            lb.numberOfLines = 0
            lb.attributedText = self.setupAttributeForText(amonut: "\(99)", keyword: "posts")
            lb.textAlignment = .center
        return lb
    }()
    
    lazy var followersLabel:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.attributedText = self.setupAttributeForText(amonut: "30", keyword: "followers")
          lb.textAlignment = .center
        return lb
    }()
    
    lazy var followingLabel:UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
         lb.attributedText = self.setupAttributeForText(amonut: "40", keyword: "following")
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var editOrFollow:UIButton = {
        let bt = UIButton(type: .system)
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 1
        bt.setTitle("Edit Profile", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.addTarget(self, action: #selector(handleFollowOrEditing), for: .touchUpInside)
        return bt
    }()
    
   @objc fileprivate func handleFollowOrEditing(){
    guard let currentUserID = Auth.auth().currentUser?.uid else {return}
    guard let userId = user?.uid else {return}
    
    if userId == currentUserID {
        //edit
        return
    }else{
        
        if editOrFollow.titleLabel?.text == "Follow" {
            APIService.shard.tofollowUser(currentUid: currentUserID, followeID: userId) { (error) in
                if let err = error {
                     print("error",err.localizedDescription)
                    return
                }
            }
            self.unfollowStyle()
        }else if editOrFollow.titleLabel?.text == "Unfollow"{
            APIService.shard.toUnFollow(currentUid: currentUserID, followeID: userId) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
            }
            
            self.followStyle()
        }
        
    }
}
    
    let userNameLabel:UILabel = {
        let lb = UILabel()
            lb.text = "userName"
            lb.font = UIFont.boldSystemFont(ofSize: 18)
        return lb
    }()
    
    
     func setupAttributeForText(amonut:String,keyword:String)->NSAttributedString{
        
        let attributes = NSMutableAttributedString(attributedString: NSAttributedString(string: amonut + "\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        attributes.append(NSAttributedString(string: keyword, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .regular),NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
        
        return attributes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setpuLayout()
        setupBottomBar()
        setupInfoBar()
    }
    
    fileprivate func setupInfoBar(){
        
        let stack = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
            stack.distribution = .fillEqually
            stack.axis = .horizontal
        addSubview(stack)
        addSubview(editOrFollow)
        stack.anchor(top: topAnchor, leading: profileImgView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 50))
        editOrFollow.anchor(top: stack.bottomAnchor, leading: stack.leadingAnchor, bottom: nil, trailing: stack.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 32))
    }
    
    
    fileprivate func setupBottomBar(){
        
        let topVIew = UIView()
            topVIew.backgroundColor = .lightGray
        
        let bottomVIew = UIView()
            bottomVIew.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,ribbonButton])
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
        
        addSubview(stackView)
        addSubview(topVIew)
        addSubview(bottomVIew)
        
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        topVIew.anchor(top: stackView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
        bottomVIew.anchor(top: nil, leading: leadingAnchor, bottom: stackView.bottomAnchor, trailing: trailingAnchor,padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 0.5))
        
    }
    fileprivate func setpuLayout(){
        addSubview(profileImgView)
        let width:CGFloat = 80
        
        profileImgView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0), size: CGSize(width: width, height: width))
        profileImgView.layer.cornerRadius = width / 2
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImgView.bottomAnchor, leading: profileImgView.leadingAnchor, bottom: nil, trailing: trailingAnchor,padding: .init(top: 16, left: 0, bottom: 0, right: 0))
        
    
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
