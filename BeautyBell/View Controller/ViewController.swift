//
//  ViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit
//import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth


class ViewController: UIViewController {
  
    lazy var textFieldUserName: UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .lightGray
        txtField.isSecureTextEntry = false
        txtField.placeholder = "Name"
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.cornerRadius = 5
        return txtField
    }()
    lazy var textFieldPassword: UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = .lightGray
        txtField.isSecureTextEntry = true
        txtField.placeholder = "Password"
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.cornerRadius = 5
        return txtField
    }()
    lazy var buttonLogIN: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log In", for: .normal)
        btn.backgroundColor = UIColor.blue
        return btn
    }()
    lazy var buttonFacebook: FBLoginButton = {
        let btn = FBLoginButton()
        btn.permissions = ["public_profile", "email"]
        return btn
    }()
    lazy var buttonGoogle: GIDSignInButton = {
        let btn = GIDSignInButton()
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        buttonFacebook.delegate = self
        checkLoginViaFB()
// For google sign in, not finished yet
//        GIDSignIn.sharedInstance().presentingViewController = self
//        if GIDSignIn.sharedInstance().currentUser != nil {
//            
//        }else{
//            GIDSignIn.sharedInstance().signIn()
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutUI()
    }
}

extension ViewController{
    func checkLoginViaFB(){
        if let token = AccessToken.current,!token.isExpired {
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                print("\(result)")
            }
            buttonTapped()
        }
    }
    
    func initUI(){
        view.backgroundColor = .white
        view.addSubview(textFieldUserName)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonLogIN)
        view.addSubview(buttonGoogle)
        view.addSubview(buttonFacebook)
        
        buttonLogIN.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    func layoutUI(){
        let lbl = UILabel()
        lbl.text = "Login Manual"
        lbl.textAlignment = .center
        view.addSubview(lbl)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 144).isActive = true
        lbl.widthAnchor.constraint(equalToConstant: 250).isActive = true
        lbl.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        textFieldUserName.translatesAutoresizingMaskIntoConstraints = false
        textFieldUserName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldUserName.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant: 50).isActive = true
        textFieldUserName.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textFieldUserName.heightAnchor.constraint(equalToConstant: 40).isActive = true

        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        textFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFieldPassword.topAnchor.constraint(equalTo: textFieldUserName.bottomAnchor, constant: 20).isActive = true
        textFieldPassword.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textFieldPassword.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonLogIN.translatesAutoresizingMaskIntoConstraints = false
        buttonLogIN.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonLogIN.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 20).isActive = true
        buttonLogIN.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonLogIN.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let lblSocmed = UILabel()
        lblSocmed.text = "Login Via Social Media"
        lblSocmed.textAlignment = .center
        view.addSubview(lblSocmed)
        
        lblSocmed.translatesAutoresizingMaskIntoConstraints = false
        lblSocmed.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblSocmed.topAnchor.constraint(equalTo: buttonLogIN.bottomAnchor, constant: 40).isActive = true
        lblSocmed.widthAnchor.constraint(equalToConstant: 250).isActive = true
        lblSocmed.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        buttonGoogle.translatesAutoresizingMaskIntoConstraints = false
        buttonGoogle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonGoogle.topAnchor.constraint(equalTo: lblSocmed.bottomAnchor, constant: 20).isActive = true
        buttonGoogle.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonGoogle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonFacebook.translatesAutoresizingMaskIntoConstraints = false
        buttonFacebook.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonFacebook.topAnchor.constraint(equalTo: buttonGoogle.bottomAnchor, constant: 20).isActive = true
        buttonFacebook.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonFacebook.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func buttonTapped(){
        let tabVC = UITabBarController()
        tabVC.addChild(HomeViewController())
        tabVC.addChild(ProfileViewController())
        self.navigationController?.pushViewController(tabVC, animated: true)
    }
}
extension ViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { connection, result, error in
            print("\(result)")
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}
