//
//  LoginController.swift
//  InstgramCopy
//
//  Created by 洪森達 on 2018/12/31.
//  Copyright © 2018 洪森達. All rights reserved.
//

import UIKit
import JGProgressHUD
class LoginViewController:UIViewController{
   
    let logoContainerVIew:UIView = {
        let view = UIView()
            view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
            imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil
            , padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 200, height: 50))
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let transportRegisterButton:UIButton = {
        let bt = UIButton(type: .system)
        let attributeS = NSMutableAttributedString(attributedString: NSAttributedString(string: "Don't have an account?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize:18)]))
        attributeS.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
        bt.setAttributedTitle(attributeS, for: .normal)
        bt.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return bt
    }()
    
    
    let emailTextField:UITextField = {
        let tf = CustomTextField()
        tf.placeholder = "Passwords"
        tf.backgroundColor = UIColor(white: 1, alpha: 0.83)
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
    
   @objc fileprivate func handleEditingChanged(){
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordsTextField.text?.characters.count ?? 0 > 0
        
    if isFormValid {
        signInButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        signInButton.isEnabled = true
    }else {
        signInButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        signInButton.isEnabled = false
    }

    }
    
    let signInButton:UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        bt.layer.cornerRadius = 5
        bt.isEnabled = false
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        bt.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return bt
    }()
    
    @objc fileprivate func handleSignIn(){
        let hub = JGProgressHUD(style: .dark)
            hub.textLabel.text = "Log In..."
        hub.show(in: self.view)
       
        guard let email = emailTextField.text , let passwords = passwordsTextField.text else {return}
        APIService.shard.signInWith(email: email, passwords: passwords) { (errpr) in
            
            if let error = errpr {
                hub.textLabel.text = error.localizedDescription
                hub.dismiss(afterDelay: 3)
                return
            }
            guard let mainController = UIApplication.shared.keyWindow?.rootViewController as? MainTabController else {return}
            mainController.seupViews()
            hub.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @objc fileprivate func handleRegister(){
        let rv = RegisterController()
        navigationController?.pushViewController(rv, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard)))
    }
    
   @objc fileprivate func handleDismissKeyboard(){
        view.endEditing(true)
    }
    fileprivate func setupLayout(){
        view.addSubview(logoContainerVIew)
        view.addSubview(transportRegisterButton)
        transportRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 50))
        
        logoContainerVIew.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 150))
        
        let stack = UIStackView(arrangedSubviews: [emailTextField,passwordsTextField,signInButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually
        view.addSubview(stack)
        
        stack.anchor(top: logoContainerVIew.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16), size: CGSize(width: 0, height: 128))
    }
}
