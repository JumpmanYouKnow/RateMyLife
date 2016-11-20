//
//  UserInfomation.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-20.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

class User{
    var userID : String?
    var userName : String?
    var userProfileImage : UIImage?{
        didSet {
            if userProfileImageView != nil{
                print("herere")
                userProfileImageView?.image = userProfileImage
            }
        }
    }
    var userProfileImageView : UIImageView?
    
    init(userName : String, userID : String){
        self.userName = userName
        self.userID = userID
    }
    
    func createButtonView(_ frame: CGRect) -> UIView{
        let container = UIView(frame: frame)
        
        userProfileImageView = UIImageView(frame: CGRect(x: 10, y:5, width: 50 , height: 50))
        userProfileImageView!.layer.cornerRadius = 10.0
        userProfileImageView!.layer.borderWidth = 2.0
        userProfileImageView!.layer.borderColor = UIColor.white.cgColor as CGColor
        userProfileImageView!.clipsToBounds = true
        
        if let img = userProfileImage{
            userProfileImageView!.image = img
        }
        else{
            userProfileImageView!.image = UIImage(named: "circle")
        }
        
        container.addSubview(userProfileImageView!)
        
        let titleLabel = UILabel(frame: CGRect(x: userProfileImageView!.frame.width  + 25 , y: 5, width: frame.size.width - userProfileImageView!.frame.width, height: 50))
        titleLabel.text = self.userName
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Teen-Bold", size: 25)
        
        container.addSubview(titleLabel)
        container.layer.borderColor = AppColor.dividerColor3.cgColor
        container.layer.borderWidth = 2
        container.backgroundColor = UIColor.white
        return container
    }

    
}
