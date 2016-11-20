//
//  FirstViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit
import SwipeViewController
import CircleSlider

class RatingViewController: SwipeViewController {
    
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lifeRate = LifeRatingViewController()
        lifeRate.user = user
        lifeRate.view.backgroundColor = AppColor.dividerColor2
        lifeRate.title = "Life"
        
        let carRate = CarRatingViewController()
        carRate.view.backgroundColor = AppColor.dividerColor2
        carRate.title = "Car"
        
        setViewControllerArray([lifeRate, carRate])
        
        setFirstViewController(0)
        //
        //        //Button with image example
        //        //let buttonOne = SwipeButtonWithImage(image: UIImage(named: "Hearts"), selectedImage: UIImage(named: "YellowHearts"), size: CGSize(width: 40, height: 40))
        //        //setButtonsWithImages([buttonOne, buttonOne, buttonOne])
        //
        //        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(push))
        //        setNavigationWithItem(UIColor.white, leftItem: barButtonItem, rightItem: nil)
        
        setSelectionBar(80, height: 2, color: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        setButtonsWithSelectedColor(UIFont.systemFont(ofSize: 22), color: UIColor.black, selectedColor: UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0))
        equalSpaces = false
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

