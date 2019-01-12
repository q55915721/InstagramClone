//
//  CustomImageView.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/2.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
var imageCaches = [String:UIImage]()
class CustomImageView:UIImageView{
    
    var lastImgUrl:String?
    
    func loadImg(urlString:String){
        lastImgUrl = urlString
        
        if let cacheImg = imageCaches[urlString]{
            self.image = cacheImg
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (imgData, _, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if self.lastImgUrl != url.absoluteString {
                return
            }
            guard let data = imgData else {return}
            let image = UIImage(data: data)
            imageCaches[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
         
    }
}
