//
//  PhotoSelectorCell.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/1.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class PhotoSelectorCell:UICollectionViewCell {
    
    let photoImage:UIImageView = {
        let iv = UIImageView()
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
