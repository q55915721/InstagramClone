//
//  CommentsCell.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/8.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage

class CommentsCell: UICollectionViewCell {
    
    
    var comment:Comment!{
        
        didSet{
            guard let url = URL(string:comment.user.profileImgString ?? "") else {return}
            userProfileImg.sd_setImage(with: url)
            setLableAttribute()
        }
    }
    
    fileprivate func setLableAttribute(){
        
        guard let userName = comment.user.userName else {return}
        
        let mutableAttributeString = NSMutableAttributedString(attributedString: NSAttributedString(string: userName + " ", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        
        
        mutableAttributeString.append(NSAttributedString(string:comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        userInfoLabel.attributedText = mutableAttributeString
    }

    let userProfileImg:UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
        return iv
    }()
    
    let userInfoLabel:UILabel = {
        let lb = UILabel()
            lb.text = "userName comment's content"
            lb.numberOfLines = 0
        return lb
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImg)
        
        userProfileImg.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 40, height: 40))
        userProfileImg.layer.cornerRadius = 40 / 2
        
        addSubview(userInfoLabel)
        userInfoLabel.anchor(top: topAnchor, leading: userProfileImg.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        let separatorView = UIView()
            separatorView.backgroundColor = .lightGray
        addSubview(separatorView)
        separatorView.anchor(top: nil, leading: userInfoLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8), size: CGSize(width: 0, height: 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
