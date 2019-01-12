//
//  SearchCell.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/5.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage


class SearchCell: UICollectionViewCell {
    
    
    var user:User?{
        didSet{
            guard let url = URL(string: user?.profileImgString ?? "") else {return}
            profileImg.sd_setImage(with: url)
            usernameLabel.text = user?.userName ?? ""
        }
    }
    
    let profileImg:UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.backgroundColor = .lightGray
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        addSubview(profileImg)
        addSubview(usernameLabel)
        profileImg.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil
            , padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        profileImg.layer.cornerRadius = 50 / 2
        
        usernameLabel.anchor(top: topAnchor, leading: profileImg.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separator)
        separator.anchor(top: nil, leading: usernameLabel.leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0.5))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
