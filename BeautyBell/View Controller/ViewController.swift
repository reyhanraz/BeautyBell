//
//  ViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn


class ViewController: UIViewController {
  
    lazy var textFieldUserName: UITextField = {
        let txtField = UITextField()
        txtField.isSecureTextEntry = false
        txtField.placeholder = " Name"
        txtField.clipsToBounds = true
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.cornerRadius = 5
        txtField.setPaddingPoints(5, 5)
        return txtField
    }()
    lazy var textFieldPassword: UITextField = {
        let txtField = UITextField()
        txtField.isSecureTextEntry = true
        txtField.placeholder = " Password"
        txtField.clipsToBounds = true
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.black.cgColor
        txtField.layer.cornerRadius = 5
        txtField.setPaddingPoints(5, 5)
        return txtField
    }()
    lazy var buttonLogIN: UIButton = {
        let btn = UIButton()
        btn.setTitle("Log In", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.systemPink.cgColor
        btn.layer.borderWidth = 2.0
        return btn
    }()
    
    lazy var buttonGoogle: UIButton = {
        let btn = UIButton()
        btn.setTitle("Google Log In", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.systemPink.cgColor
        btn.layer.borderWidth = 2.0
        return btn
    }()
    
    let FBloginButton = FBLoginButton(frame: .zero, permissions: ["public_profile", "email", "user_birthday"])
    
    lazy var buttonFacebook: UIButton = {
        let btn = UIButton()
        btn.setTitle("Facebook Log In", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.systemPink.cgColor
        btn.layer.borderWidth = 2.0
        return btn
    }()
    lazy var buttonRegistre: UIButton = {
       let btn = UIButton()
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(UIColor.systemPink, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 20
        btn.layer.borderColor = UIColor.systemPink.cgColor
        btn.layer.borderWidth = 2.0
        return btn
    }()
    
    private let btnGIDSignin = GIDSignInButton()

    private var loginObserver: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        FBloginButton.delegate = self
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.buttonLogIN.sendActions(for: .touchUpInside)
        })
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name,user_birthday"], tokenString: token, version: nil, httpMethod: .get)
            request.start { connection, result, error in
                
                    print("\(result)")
                    self.buttonLogIN.sendActions(for: .touchUpInside)

            }
        }
    }
    
    func initUI(){
        view.backgroundColor = .white
        view.addSubview(textFieldUserName)
        view.addSubview(textFieldPassword)
        view.addSubview(buttonLogIN)
        view.addSubview(buttonGoogle)
        view.addSubview(buttonFacebook)
        view.addSubview(buttonRegistre)
        
        buttonLogIN.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttonRegistre.addTarget(self, action: #selector(buttonRegisterTapped), for: .touchUpInside)
        buttonFacebook.addTarget(self, action: #selector(buttonFacebookTapped),for: .touchUpInside)
        buttonGoogle.addTarget(self, action: #selector(buttonGoogleTapped),for: .touchUpInside)


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
        buttonLogIN.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16).isActive = true
        buttonLogIN.widthAnchor.constraint(equalToConstant: 250).isActive = true
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
        buttonGoogle.topAnchor.constraint(equalTo: lblSocmed.bottomAnchor, constant: 16).isActive = true
        buttonGoogle.widthAnchor.constraint(equalToConstant: 250).isActive = true
        buttonGoogle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        buttonFacebook.translatesAutoresizingMaskIntoConstraints = false
        buttonFacebook.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonFacebook.topAnchor.constraint(equalTo: buttonGoogle.bottomAnchor, constant: 16).isActive = true
        buttonFacebook.widthAnchor.constraint(equalToConstant: 250).isActive = true
        buttonFacebook.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        buttonRegistre.translatesAutoresizingMaskIntoConstraints = false
        buttonRegistre.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonRegistre.topAnchor.constraint(equalTo: buttonFacebook.bottomAnchor, constant: 16).isActive = true
        buttonRegistre.widthAnchor.constraint(equalToConstant: 250).isActive = true
        buttonRegistre.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    @objc private func buttonTapped(sender: UIButton){
        animateButton(sender) {
            self.navigationController?.pushViewController(TabBarViewController(), animated: true)
        }
    }
    @objc private func buttonFacebookTapped(sender: UIButton){
        animateButton(sender) {
            self.FBloginButton.sendActions(for: .touchUpInside)
        }
    }
    
    @objc private func buttonRegisterTapped(sender: UIButton){
        animateButton(sender) {
            self.navigationController?.present(RegisterViewController(), animated: true, completion: nil)
        }
    }
    @objc private func buttonGoogleTapped(sender: UIButton){
        animateButton(sender) {
            self.btnGIDSignin.sendActions(for: .touchUpInside)
        }
    }
    private func animateButton(_ view: UIButton, actionButtonClosure: @escaping () -> Void){
        UIView.animate(withDuration: 0.2) {
            view.pulsate()
        } completion: { _ in
            actionButtonClosure()
        }
    }

}
extension ViewController: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }

        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":
                                                            "email, first_name, last_name, picture.type(large),birthday"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)

        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String: Any],
                error == nil else {
                    print("Failed to make facebook graph request")
                    return
            }

            print(result)

            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let pictureUrl = data["url"] as? String,
                let birthday = result["birthday"] as? String else {
                    print("Faield to get email and name from fb result")
                    return
            }
            
            let users = Users(name: "\(firstName) \(lastName)", imageURL: pictureUrl, dateOfBirth: birthday, email: email)
            UserProfileCache.save(users)

//            DatabaseManager.shared.userExists(with: email, completion: { exists in
//                if !exists {
//                    let chatUser = ChatAppUser(firstName: firstName,
//                                               lastName: lastName,
//                                               emailAddress: email)
//                    DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
//                        if success {
//
//                            guard let url = URL(string: pictureUrl) else {
//                                return
//                            }
//
//                            print("Downloading data from facebook image")
//
//                            URLSession.shared.dataTask(with: url, completionHandler: { data, _,_ in
//                                guard let data = data else {
//                                    print("Failed to get data from facebook")
//                                    return
//                                }
//
//                                print("got data from FB, uploading...")
//
//                                // upload iamge
//                                let filename = chatUser.profilePictureFileName
//                                StorageManager.shared.uploadProfilePicture(with: data, fileName: filename, completion: { result in
//                                    switch result {
//                                    case .success(let downloadUrl):
//                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
//                                        print(downloadUrl)
//                                    case .failure(let error):
//                                        print("Storage maanger error: \(error)")
//                                    }
//                                })
//                            }).resume()
//                        }
//                    })
//                }
//            })

            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }

                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    return
                }

                print("Successfully logged user in")
                strongSelf.buttonLogIN.sendActions(for: .touchUpInside)
            })
        })
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    
}
