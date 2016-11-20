//
//  LifeRatingViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import CircleSlider
import UIKit

class CarRatingViewController : UIViewController{
    
    var circleSlider : CircleSlider?
    var progressLabel: UILabel!
    var progressValue: Float = 0
    
    var timer: Timer?
    var scoreView: UIView!
    
    lazy var logoImage: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RateMyCar")
        imageView.backgroundColor = UIColor.white
        imageView.frame = CGRect(x: 23, y: 50,  width: self.view.frame.width - 40 , height: 80 )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        self.progressLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.progressLabel.textAlignment = .center
        self.progressLabel.numberOfLines = 3
        self.progressLabel.text = "0"
        self.progressLabel.font =  UIFont(name: "breipfont", size: 50)
        self.progressLabel.textColor = AppColor.appBlue
        
        self.view.addSubview(logoImage)
        initScoreView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
    }
    
    func initScoreView(){
        let view = UIView()
        circleSlider = CircleSlider(frame: CGRect(x: self.view.frame.width / 2 - 185, y: -50, width: 370, height: 370) , options: [.barColor(UIColor.white),
                                                                                                                                   .trackingColor(UIColor.red),
                                                                                                                                   .barWidth(35),
                                                                                                                                   .sliderEnabled(false)])
        circleSlider?.isUserInteractionEnabled = false
        //circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
        view.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.progressLabel.center = CGPoint(x: (self.circleSlider?.bounds.width)! * 0.5, y: self.circleSlider!.bounds.height * 0.5)
        self.circleSlider?.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        self.circleSlider?.addSubview(progressLabel)
        
        //view.backgroundColor = AppColor.themeColor
        view.addSubview(circleSlider!)
        self.progressValue = 0
        self.scoreView = view
        self.view.addSubview(scoreView)
        
    }
    
    func valueChange(sender: CircleSlider) {
        let stringOne = "Score \n\(Int(sender.value))"
        let stringTwo = "\n\(Int(sender.value))"
        
        let stringTwoRange = (stringOne as NSString).range(of: stringTwo)
        
        let attributedString = NSMutableAttributedString(string: stringOne,attributes: [NSFontAttributeName : UIFont(name: "breipfont", size: 55)!, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue])
        
        attributedString.setAttributes([NSFontAttributeName : UIFont(name: "Teen-Bold", size: 70)!,NSForegroundColorAttributeName : UIColor.red], range: stringTwoRange)
        self.progressLabel.attributedText = attributedString
        //  self.progressLabel.text = "Score : " + "\n\(Int(sender.value))"
    }
    
    func fire(timer: Timer) {
        self.progressValue += 0.5
        if self.progressValue > 88 {
            self.timer?.invalidate()
            self.timer = nil
            self.progressValue = 88
        }
        self.circleSlider?.value = self.progressValue
    }
    
}
