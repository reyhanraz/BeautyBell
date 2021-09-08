//
//  ProfileView.swift
//  BeautyBell
//
//  Created by Reyhan Rifqi on 10/07/21.
//

import UIKit
import L10n_swift

class ProfileView: UIView {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDOB: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    

    var userViewModel: UserViewModel?{
        didSet{
            self.userName.text = userViewModel?.userName
            self.userDOB.text = userViewModel?.userDOB
            self.userEmail.text = userViewModel?.userEmail
            userViewModel?.loadImage { image in
                DispatchQueue.main.async {
                    self.userImage.image = image
                }
            }
        }
    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        roundImage()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func roundImage(){
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
   
}

