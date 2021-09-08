//
//  UserViewController.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 10/07/21.
//

import UIKit
import L10n_swift
class UserViewController: UIViewController {
    var profile = ProfileView()
    var userViewModel: UserViewModel?
    
    lazy var tableView: UITableView = {
        let v = UITableView()
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        v.delegate = self
        v.dataSource = self
        
        return v
    }()
    
    lazy var switchControl: UISwitch = {
        let v = UISwitch()
        v.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        return v
    }()

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
        view.addSubview(tableView)
    }
    
    func layoutUI(){
        profile.translatesAutoresizingMaskIntoConstraints = false
        profile.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profile.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profile.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profile.heightAnchor.constraint(greaterThanOrEqualToConstant: 190).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: profile.bottomAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 190).isActive = true

    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "language".l10n()
        cell.accessoryView = switchControl
        
        return cell
    }
    
    
}
