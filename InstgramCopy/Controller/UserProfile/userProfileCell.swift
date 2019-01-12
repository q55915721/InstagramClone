//
//  userProfileCell.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/2.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import SDWebImage
class UserProfileCell: UICollectionViewCell {
    
    
    var post:Post? {
        
        didSet{
//            photoImage.setupImageCacheWithURl(post?.imageUrl ?? "")
//            photoImage.loadImg(urlString: post?.imageUrl ?? "")
           guard let url = URL(string: post?.imageUrl ?? "") else {return}
            photoImage.sd_setImage(with: url)
        }
    }
    
    let photoImage:CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImage)
        photoImage.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
