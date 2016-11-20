//
//  CarViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

class CarViewController : CommonViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCategories()
    }
    
    func initCategories(){
        let speedButton = CommonButton(frame: CGRect(x: 12, y: 12, width: UIScreen.main.bounds.width / 2 - 20, height:
            UIScreen.main.bounds.width / 2 - 20))
        speedButton.setImage(UIImage(named: "speed"), for: .normal)
        speedButton.setTitle("Speed", for: .normal)
        speedButton.titleLabel?.font = UIFont(name: "breipfont", size: 50)
        speedButton.setTitleColor(UIColor.white, for: .normal)
        speedButton.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
        speedButton.titleEdgeInsets = UIEdgeInsetsMake(10, -250 ,0,0)
        speedButton.backgroundColor = AppColor.lightRed
        //speedButton.addTarget(self, action: #selector(exerciseButtonAction), for: .touchUpInside)
        
        let distanceButton = CommonButton(frame: CGRect(x: speedButton.frame.maxX + 15 , y: 12, width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20))
        distanceButton.setImage(UIImage(named: "distance"), for: .normal)
        distanceButton.setTitle("Distance", for: .normal)
        distanceButton.titleLabel?.font = UIFont(name: "breipfont", size: 50)
        distanceButton.setTitleColor(UIColor.white, for: .normal)
        
        distanceButton.backgroundColor = AppColor.lightBlue
        distanceButton.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
        distanceButton.titleEdgeInsets = UIEdgeInsetsMake(10, -250 ,0,0)
//
//        
//        let foodButton = CommonButton(frame: CGRect(x: 12, y: walkButton.frame.maxY + 12, width: UIScreen.main.bounds.width / 2 - 20, height:
//            UIScreen.main.bounds.width / 2 - 20))
//        
//        foodButton.setImage(UIImage(named: "food"), for: .normal)
//        foodButton.setTitle("Food", for: .normal)
//        foodButton.titleLabel?.font = UIFont(name: "breipfont", size: 50)
//        foodButton.setTitleColor(UIColor.white, for: .normal)
//        
//        foodButton.backgroundColor = AppColor.lightOrange
//        foodButton.addTarget(self, action: #selector(foodButtonAction), for: .touchUpInside)
//        
//        
//        let heartButton = CommonButton(frame: CGRect(x: walkButton.frame.maxX + 15 , y: 12, width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20))
//        heartButton.setImage(UIImage(named: "heart"), for: .normal)
//        heartButton.setTitle("Heart", for: .normal)
//        heartButton.titleLabel?.font = UIFont(name: "breipfont", size: 50)
//        heartButton.setTitleColor(UIColor.white, for: .normal)
//        
//        heartButton.backgroundColor = AppColor.lightPink
//        heartButton.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
//        heartButton.titleEdgeInsets = UIEdgeInsetsMake(10, -250 ,0,0)
//        //heartButton.addTarget(self, action: #selector(foodButtonAction), for: .touchUpInside)
//        
//        let workButton = CommonButton(frame: CGRect(x: 12 , y: foodButton.frame.maxY + 12, width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20))
//        workButton.setImage(UIImage(named: "stress"), for: .normal)
//        workButton.setTitle("Stress", for: .normal)
//        workButton.titleLabel?.font = UIFont(name: "breipfont", size: 50)
//        workButton.setTitleColor(UIColor.white, for: .normal)
//        
//        workButton.backgroundColor = AppColor.blue2
//        workButton.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
//        workButton.titleEdgeInsets = UIEdgeInsetsMake(10, -120 ,0,0)
//        
//        let addButton = CommonButton(frame: CGRect(x: walkButton.frame.maxX + 15 , y: foodButton.frame.maxY + 12, width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20))
//        addButton.setImage(UIImage(named: "add"), for: .normal)
//        addButton.setTitle("Customize", for: .normal)
//        addButton.titleLabel?.font = UIFont(name: "breipfont", size:45)
//        addButton.setTitleColor(UIColor.white, for: .normal)
//        
//        addButton.backgroundColor = AppColor.lightGreen
//        addButton.imageEdgeInsets = UIEdgeInsetsMake(50, 50, 0, 0)
//        addButton.titleEdgeInsets = UIEdgeInsetsMake(10, -250 ,0,0)
//        
//        //        let sleepButton = CommonButton(frame: CGRect(x: walkButton.frame.maxX + 15 , y: 12, width: UIScreen.main.bounds.width / 2 - 20, height: UIScreen.main.bounds.width / 2 - 20))
//        
//        self.view.addSubview(foodButton)
//        self.view.addSubview(heartButton)
        self.view.addSubview(speedButton)
        self.view.addSubview(distanceButton)
//        self.view.addSubview(addButton)
//        self.view.addSubview(workButton)
        
    }

    
    
}
