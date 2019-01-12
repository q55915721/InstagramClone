

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSave() {
        print("saveBtn")
        guard let image = previewImageView.image else {return}
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
            
        }) { (success, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                
            
                let lb = UILabel()
                    lb.text = "Successfully save the Photo!"
                    lb.font = UIFont.boldSystemFont(ofSize: 18)
                    lb.numberOfLines = 0
                    lb.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
                    lb.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                    lb.textColor = .white
                    lb.textAlignment = .center
                self.addSubview(lb)
                lb.center = self.center
                lb.layer.transform = CATransform3DMakeScale(0, 0, 0)
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    lb.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (_) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            lb.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                            lb.alpha = 0
                    }, completion: { (_) in
                        lb.removeFromSuperview()
                    })
                })
            
            }
        }
     
    }
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(previewImageView)
        previewImageView.fillSuperview()
        
        addSubview(cancelButton)
        
        cancelButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
    
        
        addSubview(saveButton)
        
        saveButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 0), size: CGSize(width: 50, height: 50))
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
