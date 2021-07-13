//
//  UserViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 10/07/21.
//

import UIKit

class UserViewController: UIViewController {
    var profile = ProfileView()
    var userViewModel: UserViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initui(userViewModel: userViewModel ?? UserViewModel(user: Users(name: "", imageURL: "", dateOfBirth: "", email: "")))
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
extension UserViewController{
    func initui(userViewModel: UserViewModel){
        profile.userViewModel = userViewModel
        view.addSubview(profile)
    }
    
    func layoutUI(){
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profile.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profile.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profile.heightAnchor.constraint(greaterThanOrEqualToConstant: 190).isActive = true

    }
}
