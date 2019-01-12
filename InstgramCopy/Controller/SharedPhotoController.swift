//
//  SharedPhotoController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/2.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import JGProgressHUD



class SharadPhotoController:UIViewController {
    
    


    var selectedImg:UIImage!{
        didSet{
            photoImgView.image = selectedImg
        }
    }
    
   
    
    let photoImgView:UIImageView = {
        let iv = UIImageView()
            iv.clipsToBounds = true
            iv.backgroundColor = .red
            iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let textView:UITextView = {
        let tv = UITextView()
            tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupLayout()
        setupNavigationButton()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissal)))
        
    }
    @objc fileprivate func handleDismissal(){
        view.endEditing(true)
    }
    
    fileprivate func setupLayout(){
        let containerView = UIView()
            containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 100))
        
        containerView.addSubview(photoImgView)
        photoImgView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 0), size: CGSize(width: 80, height: 80))
        
        containerView.addSubview(textView)
        textView.anchor(top: photoImgView.topAnchor, leading: photoImgView.trailingAnchor, bottom: nil, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8), size: CGSize(width: 0, height: 80))
        
    }
    
    fileprivate func setupNavigationButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shard", style: .plain, target: self, action: #selector(handleShared))
    }
    
    static let notificationNameForRefresh = NSNotification.Name(rawValue: "notificationNameForRefresh")
    
    @objc fileprivate func handleShared(){
    
        guard let text = textView.text , textView.text.characters.count > 0 else {return}
        let jpg = JGProgressHUD(style: .dark)
            jpg.textLabel.text = "Update..."
            jpg.show(in: self.view)
     
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        APIService.shard.updatePostFromUser(image: selectedImg, text: text) { (error) in
            if let err = error {
                print("err",err.localizedDescription)
                jpg.dismiss()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            self.dismiss(animated: true, completion: {
                jpg.dismiss()
                NotificationCenter.default.post(name: SharadPhotoController.notificationNameForRefresh, object: nil)
            })
           
        }
    
    
    
    }
}
