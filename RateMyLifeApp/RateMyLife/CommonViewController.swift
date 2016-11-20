//
//  CommonViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

class CommonViewController : UIViewController{
    
    var subviewsRecord : [UIView] = [UIView]()
    
    func discardViews(subview : UIView){
        
        for view in self.view.subviews{
            if view != subview{
                view.removeFromSuperview()
                subviewsRecord.append(view)
            }
        }
    }
    
    func restoreViews(){
        for view in self.subviewsRecord{
            self.view.addSubview(view)
        }
    }
}



class CommonButton : UIButton {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.contentHorizontalAlignment = .left
        self.contentVerticalAlignment = .top
        self.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(10, -120 ,0,0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
