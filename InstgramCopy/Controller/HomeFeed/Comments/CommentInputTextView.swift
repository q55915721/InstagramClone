//
//  CommentInputTextView.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/12.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    let placeHolder:UILabel = {
        let lb = UILabel()
            lb.text = "Enter Comments."
            lb.textColor = .lightGray
            lb.font = UIFont.systemFont(ofSize: 18)
        return lb
    }()
    
    func showPlaceholderLabel() {
        placeHolder.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolder)
        placeHolder.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanges), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc func handleTextChanges(){
        placeHolder.isHidden = !self.text.isEmpty
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
