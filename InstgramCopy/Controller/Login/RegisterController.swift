//
//  ViewController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/24.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import JGProgressHUD



class RegisterController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let plusButton:UIButton = {
        let bt = UIButton(type: .system)
            bt.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleImgPicker), for: .touchUpInside)
        bt.imageView?.contentMode = .scaleAspectFill
        return bt
    }()
    
    @objc fileprivate func handleImgPicker(){
        let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImg = info[.editedImage] as? UIImage {
            plusButton.setImage(editedImg.withRenderingMode(.alwaysOriginal), for: .normal)
            
        }else if let originalImg = info[.originalImage] as? UIImage {
            plusButton.setImage(originalImg.withRenderingMode(.alwaysOriginal), for: .normal)
        }else {
            return
        }
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = UIColor.black.cgColor
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    let userNameTextField:UITextField = {
        let tf = CustomTextField()
            tf.placeholder = "User Name"
            tf.backgroundColor = UIColor(white: 1, alpha: 0.83)
            tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let transportSignInButton:UIButton = {
        let bt = UIButton(type: .system)
        let attributeS = NSMutableAttributedString(attributedString: NSAttributedString(string: "Already have an anccount?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)]))
        attributeS.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        bt.setAttributedTitle(attributeS, for: .normal)
        bt.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return bt
    }()
    
   @objc fileprivate func handleSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    let emailTextField:UITextField = {
        let tf = CustomTextField()
        tf.placeholder = "User Email"
        tf.backgroundColor = UIColor(white: 1, alpha: 0.83)
        tf.keyboardType = .emailAddress
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let passwordsTextField:UITextField = {
        let tf = CustomTextField()
        tf.placeholder = "Passwords"
        tf.backgroundColor = UIColor(white: 1, alpha: 0.83)
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let signUpButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        bt.layer.cornerRadius = 5
        bt.isEnabled = false
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        bt.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return bt
    }()
    
    @objc fileprivate func handleRegister(){
        let hub = JGProgressHUD(style: .dark)
        hub.textLabel.text = "Register"
        hub.show(in: self.view)
       
        guard let email = emailTextField.text , let passowrd = passwordsTextField.text , let userName = userNameTextField.text else {return}
        guard let image = plusButton.imageView?.image else {return}
        APIService.shard.registerUser(_email: email, _passwords: passowrd, userName: userName, image: image) { (error) in
            hub.dismiss()
            if let err = error {
                
                DispatchQueue.main.async {
                    let hub = JGProgressHUD(style: .dark)
                        hub.show(in: self.view)
                        hub.textLabel.text = err.localizedDescription
                    hub.dismiss(afterDelay: 3)
                }
                return
            }
            
            
            guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else {return}
            mainController.seupViews()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
  @objc fileprivate func handleEditingChanged(){
    
    let isValidForm = userNameTextField.text?.characters.count ?? 0 > 0 && passwordsTextField.text?.characters.count ?? 0 > 0 && emailTextField.text?.characters.count ?? 0 > 0
    
    if isValidForm {
        signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        signUpButton.isEnabled = true
    }else {
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        signUpButton.isEnabled = false
    }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    @objc fileprivate func handleDismissKeyboard(){
        view.endEditing(true)
    }
    
    fileprivate func setupLayout(){
        let width:CGFloat = 140
        view.addSubview(plusButton)
        view.addSubview(transportSignInButton)
        plusButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: width, height: width))
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.layer.cornerRadius = width / 2
        plusButton.clipsToBounds = true
        transportSignInButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        setupStackView()
        view.backgroundColor = .white
    }
    
    fileprivate func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [userNameTextField,emailTextField,passwordsTextField,signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.anchor(top: plusButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16))
    }


}//end of the class.

class CustomTextField: UITextField {
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 0, height: 40)
    }
}
