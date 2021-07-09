//
//  ProfileViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 21/06/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var imageUserPhoto: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75
        image.image = UIImage(named: "Placeholder")
        return image
    }()
    lazy var lblUserName: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        return lbl
    }()
    lazy var lblUserDOB: UILabel = {
        let lbl = UILabel()
        lbl.text = "Date of Birth"
        return lbl
    }()
    lazy var lblUserEmail: UILabel = {
        let lbl = UILabel()
        lbl.text = "Email"
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.setHidesBackButton(true, animated: true)
        self.parent?.navigationItem.searchController = nil
        self.title = "Profile"
        self.parent?.title = self.title
    }
}


extension ProfileViewController{
    func initUI(){
        view.addSubview(imageUserPhoto)
        view.addSubview(lblUserName)
        view.addSubview(lblUserDOB)
        view.addSubview(lblUserEmail)
    }
    
    func layoutUI(){
        imageUserPhoto.translatesAutoresizingMaskIntoConstraints = false
        imageUserPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageUserPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        imageUserPhoto.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageUserPhoto.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        lblUserName.translatesAutoresizingMaskIntoConstraints = false
        lblUserName.leadingAnchor.constraint(equalTo: imageUserPhoto.trailingAnchor, constant: 20).isActive = true
        lblUserName.topAnchor.constraint(equalTo: imageUserPhoto.topAnchor).isActive = true
        lblUserName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        lblUserName.heightAnchor.constraint(equalToConstant: 40).isActive = true

        lblUserDOB.translatesAutoresizingMaskIntoConstraints = false
        lblUserDOB.leadingAnchor.constraint(equalTo: imageUserPhoto.trailingAnchor, constant: 20).isActive = true
        lblUserDOB.topAnchor.constraint(equalTo: lblUserName.bottomAnchor, constant: 16).isActive = true
        lblUserDOB.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        lblUserDOB.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lblUserEmail.translatesAutoresizingMaskIntoConstraints = false
        lblUserEmail.leadingAnchor.constraint(equalTo: imageUserPhoto.trailingAnchor, constant: 20).isActive = true
        lblUserEmail.topAnchor.constraint(equalTo: lblUserDOB.bottomAnchor, constant: 16).isActive = true
        lblUserEmail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        lblUserEmail.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
