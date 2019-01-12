//
//  PhotoSelectorController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2019/1/1.
//  Copyright © 2019 洪森達. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationButton()
        setupRegisterForCell()
//        perform(#selector(fectchPhotos), with: nil, afterDelay: 1)
        fectchPhotos()
        
    }
    
   
    
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImg:UIImage?
    
    
    fileprivate func fetchOptions()->PHFetchOptions {

        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptions = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptions]
        return fetchOptions
    }
    
    
   @objc fileprivate func fectchPhotos(){
        
        let PHassets = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            PHassets.enumerateObjects { (phoasset, count, up) in
                
                let imageManager = PHImageManager.default()
                let targetsize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: phoasset, targetSize: targetsize, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, _) in
                    guard let image = image else {return}
                    self.images.append(image)
                    self.assets.append(phoasset)
                    
                    if self.selectedImg == nil {
                        self.selectedImg = image
                    }
                    
                    if count == self.images.count - 1 {
                        DispatchQueue.main.async {
                         
                            self.collectionView.reloadData()
                        }
                    }
                    
                })
            }
        }
        
   
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    fileprivate let headerId = "headerId"
    fileprivate let cellID = "cellId"
    
    fileprivate func setupRegisterForCell(){
        collectionView.backgroundColor = .white
        collectionView.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    var headerView:UIImage!
    //MARK: -header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeaderCell
        header.backgroundColor = .lightGray
        header.photoImage.image = selectedImg
       
        if let seletedIMG = selectedImg {
            let index = images.index(of:seletedIMG)
            let asset = assets[index ?? 0]
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 600, height: 600)
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
                self.headerView = image
                header.photoImage.image = image
            }
        }
    
        return header
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImg = images[indexPath.item]
        self.collectionView.reloadData()
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //MARK:-ForCell
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        cell.photoImage.image = images[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 3
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    fileprivate func setupNavigationButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK:-For navigationButton
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleNext(){
        let sharedPhotoController = SharadPhotoController()
            sharedPhotoController.selectedImg = headerView
        navigationController?.pushViewController(sharedPhotoController, animated: true)
    }
}
