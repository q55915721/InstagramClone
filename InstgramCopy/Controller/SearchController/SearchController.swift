//
//  SearchController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/5.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit


class SearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
   
    
    lazy var searchBar:UISearchBar = {
        let sb = UISearchBar()
            sb.placeholder = "Search..."
            sb.barTintColor = .gray
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
            sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filterUser = users
          
        }else{
        filterUser = users.filter({ (user) -> Bool in
            return user.userName?.lowercased().contains(searchText.lowercased()) ?? false
        })
        }
        collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellid)
        fetchUsers()
        collectionView.keyboardDismissMode = .onDrag
    }
    
    var filterUser = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers(){
       
        APIService.shard.fetchUsersFromDatabase { (users) in
            
            self.users = users
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.userName?.compare(u2.userName ?? "") == .orderedAscending
            })
            self.filterUser = self.users
            
            self.collectionView.reloadData()
            
        }
    }
    
    
    
    fileprivate func setupLayout(){
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navbar = navigationController?.navigationBar
        searchBar.anchor(top: navbar?.topAnchor, leading: navbar?.leadingAnchor, bottom: navbar?.bottomAnchor, trailing: navbar?.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    }
    
    
    //MARK:-collectionView
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
       let userProfileController = UserProfileController(collectionViewLayout:UICollectionViewFlowLayout())
        let user = filterUser[indexPath.item]
        userProfileController.userID = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterUser.count
        
    }
    fileprivate let cellid = "cellid"
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! SearchCell
        cell.user = filterUser[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
}
