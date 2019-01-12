//
//  HomeFeedCell.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/3.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage


protocol HomeFeedCellDelegate {
    func didTapComments(Post:Post)
    func didLike(for cell:HomeFeedCell)
}

class HomeFeedCell: UICollectionViewCell {
    
    
    
    var delegate:HomeFeedCellDelegate?
    
    var post:Post?{
        didSet{
            guard let postUrl = URL(string: post?.imageUrl ?? "") else {return}
            guard let userProfileUrl = URL(string: post?.user.profileImgString ?? "") else {return}
            postImgView.sd_setImage(with: postUrl)
            userAvatar.sd_setImage(with: userProfileUrl)
            userName.text = post?.user.userName ?? ""
            setupAttributedCaption()
            guard let hasliked = post?.hasLiked else {return}
            let image = hasliked ? #imageLiteral(resourceName: "like_selected"):#imageLiteral(resourceName: "like_unselected")
            likeButton.setImage(image, for: .normal)
            
        }
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.userName ?? "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: " \(post.text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        infoLabel.attributedText = attributedText
    }
    
    let postImgView:UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.backgroundColor = .lightGray
        return iv
    }()
    
   
    let userAvatar:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let userName:UILabel = {
        let lb = UILabel()
            lb.text = "UserName"
            lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    let moreButton:UIButton = {
        let bt = UIButton(type: .system)
            bt.setTitle("•••", for: .normal)
            bt.setTitleColor(UIColor.black, for: .normal)
        return bt
        
    }()
    
    lazy var likeButton:UIButton = {
        let bt = UIButton(type: .system)
            bt.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleDidLike), for: .touchUpInside)
        return bt
    }()
    
   @objc fileprivate func handleDidLike(){
        delegate?.didLike(for: self)
    }
    
    
    lazy var commentsButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleComments), for: .touchUpInside)
        return bt
    }()
    
    @objc func handleComments(){
        guard let post = self.post else {return}
        delegate?.didTapComments(Post:post)
    }
    
    let sendButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let bookMarkButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    let infoLabel:UILabel = {
        let lb = UILabel()
        let multAttri = NSMutableAttributedString(attributedString: NSAttributedString(string: "UserName", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        multAttri.append(NSAttributedString(string: "I want to eat something that could make me happeier.", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        multAttri.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))

        multAttri.append(NSAttributedString(string: "5 hour age", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.lightGray]))
            lb.attributedText = multAttri
            lb.numberOfLines = 0
//        lb.backgroundColor = .gray
        
        return lb
    
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupLayout()
        
        
    
    }
    
  
    
    fileprivate func setupLayout(){
        addSubview(userAvatar)
        addSubview(userName)
        addSubview(moreButton)
        addSubview(postImgView)
        
        
        userAvatar.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 40, height: 40))
        userAvatar.layer.cornerRadius = 40 / 2
        
        userName.anchor(top: topAnchor, leading: userAvatar.trailingAnchor, bottom: postImgView.topAnchor, trailing: moreButton.leadingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 0))
        
        moreButton.anchor(top: topAnchor, leading: nil, bottom: postImgView.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 8), size: CGSize(width: 40, height: 0))
        
        postImgView.anchor(top: userAvatar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0))
        postImgView.heightAnchor.constraint(equalTo: widthAnchor,multiplier:1).isActive = true
        setupStackView()
        addSubview(infoLabel)
        infoLabel.anchor(top: likeButton.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    
    fileprivate func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [likeButton,commentsButton,sendButton])
            stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImgView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0), size: CGSize(width: 120, height:50 ))
        addSubview(bookMarkButton)
        bookMarkButton.anchor(top: postImgView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 50))
        
      
       
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}
