//
//  CommomView.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

class CommonView : UIView{
    
    var backButton : UIButton!
    var commonViewController : CommonViewController!
    
    init(frame: CGRect, commonViewController : CommonViewController) {
        super.init(frame: frame)
        setup()
        self.commonViewController = commonViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        // Corner Radius
        layer.cornerRadius = 10.0;
        backgroundColor = UIColor.white
        
        backButton = UIButton(frame: CGRect(x: 5 , y: 5, width: 50, height: 50))
        backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "back_normal"), for: .normal)
        backButton.setImage(UIImage(named: "back_pressed"), for: .highlighted)
        backButton.layer.borderWidth = 1.5
        backButton.layer.borderColor = AppColor.dividerColor.cgColor
        backButton.backgroundColor = UIColor.white
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
    }
    
    func backButtonAction(){
        self.removeFromSuperview()
        commonViewController.restoreViews()
    }
}
