//
//  MainTabController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/30.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import Firebase

class MainTabController:UITabBarController,UITabBarControllerDelegate{
    
    
    
    
    
    fileprivate func setupUi() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
             
                let login = LoginViewController()
                let nv = UINavigationController(rootViewController: login)
                self.present(nv, animated: true, completion: nil)
            }
            return
        }
        
        seupViews()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupUi()
        
       
    }

    
     func seupViews(){
            //Home
        let homeflowLayout = UICollectionViewFlowLayout()
        let homeController = generatingViewController(img: #imageLiteral(resourceName: "home_unselected"), selectedImg: #imageLiteral(resourceName: "home_selected"),rootViewController: HomeFeedController(collectionViewLayout:homeflowLayout) )
            //Search
        let searchController = generatingViewController(img: #imageLiteral(resourceName: "search_unselected"), selectedImg: #imageLiteral(resourceName: "search_selected"),rootViewController: SearchController(collectionViewLayout:UICollectionViewFlowLayout()))
            //Photo
        let photoController = generatingViewController(img: #imageLiteral(resourceName: "plus_unselected"), selectedImg: #imageLiteral(resourceName: "plus_unselected"))
            //Heart
        let heartController = generatingViewController(img: #imageLiteral(resourceName: "like_unselected"), selectedImg: #imageLiteral(resourceName: "like_selected"))
        
        
        
        let userProfileController =         UserProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        let userProfileControllerInTabar = generatingViewController(img: #imageLiteral(resourceName: "profile_unselected"), selectedImg: #imageLiteral(resourceName: "profile_selected"),rootViewController: userProfileController)
        
        viewControllers = [
            homeController,
            searchController,
            photoController,
            heartController,
            userProfileControllerInTabar
        ]
        tabBar.tintColor = .black
        
        tabBar.items?.forEach({ (item) in
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        })
        

    }
    
    fileprivate func generatingViewController(img:UIImage,selectedImg:UIImage,rootViewController:UIViewController = UIViewController())->UIViewController{
            
        let vc = rootViewController
        let nv = UINavigationController(rootViewController: vc)
        nv.tabBarItem.image = img
        nv.tabBarItem.selectedImage = selectedImg
        return nv
        
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of:viewController)
        if index == 2 {
            
            let photoSelector = PhotoSelectorController(collectionViewLayout:UICollectionViewFlowLayout())
            let nv = UINavigationController(rootViewController: photoSelector)
            present(nv, animated: true, completion: nil)
            
            return false
        }
        
        return true
        
    }
}
