//
//  LogInWithFacebook.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FacebookCore

class LogInWithFacebook : UIViewController, LoginButtonDelegate{
    
    override func viewDidLoad() {
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        
        loginButton.frame = CGRect(x: 5, y: 4 * self.view.frame.height / 5, width: self.view.frame.width - 10, height: 50)
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height : 250))
        imageView.image = UIImage(named: "insurance")
        
        let appIcon = UIImageView(frame: CGRect(x: self.view.frame.width / 2 - 40, y: imageView.frame.maxY - 30, width: 80, height: 80))
        appIcon.image = UIImage(named : "Icon")
        appIcon.layer.borderColor = UIColor.white.cgColor
        appIcon.layer.cornerRadius = 15
        appIcon.layer.borderWidth = 1.5
        appIcon.clipsToBounds = true
        
        self.view.backgroundColor = AppColor.dividerColor2
        
        view.addSubview(imageView)
        view.addSubview(appIcon)
        
        let signUp = UIButton(frame: CGRect(x: 5,  y: loginButton.frame.maxY + 10, width: self.view.frame.width / 2 - 10, height : 50))
        signUp.layer.cornerRadius = 5
        signUp.backgroundColor = UIColor.white
        signUp.setTitle("Sign Up", for: .normal)
        signUp.setTitleColor(UIColor.black, for: .normal)
        signUp.layer.borderColor = AppColor.dividerColor.cgColor
        
        view.addSubview(signUp)
        
        let logIn = UIButton(frame: CGRect(x: self.view.frame.width / 2 + 10,  y: loginButton.frame.maxY + 10, width: self.view.frame.width / 2 - 15, height : 50))
        logIn.layer.cornerRadius = 5
        logIn.backgroundColor = UIColor.white
        logIn.setTitle("Log In", for: .normal)
        logIn.setTitleColor(UIColor.black, for: .normal)
        logIn.layer.borderColor = AppColor.dividerColor.cgColor
        
        view.addSubview(logIn)
        
    }
    func loginButtonDidCompleteLogin(_ loginButton:LoginButton,result:LoginResult){
        switch result {
        case .cancelled:
            print("Log in cancelled by user")
            break;
        case .failed:
            print("Log in Failed!")
            break;
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("Logged in!")
            print("GRANTED PERMISSIONS: \(grantedPermissions)")
            print("DECLINED PERMISSIONS: \(declinedPermissions)")
            print("ACCESS TOKEN \(accessToken)")
            sendGetRequest()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton:LoginButton){
        
    }
    
    func sendGetRequest(){
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                
                let defaults = UserDefaults.standard
                
                defaults.setValue(response.dictionaryValue?["name"] as! String, forKey: defaultsKeys.keyOne)
                defaults.setValue(response.dictionaryValue?["id"] as! String, forKey: defaultsKeys.keyTwo)
                
                defaults.synchronize()
                
                if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                    let navigationController = ActivityViewController(rootViewController: pageController)
                    
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                    
                    
                    initialViewController.viewControllers?[0] = navigationController
                    initialViewController.viewControllers?[0].tabBarItem.title = "Activity"
                    initialViewController.viewControllers?[0].tabBarItem.image = UIImage(named: "Activity")
                    
                    let pageController2 = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                    let navigationController2 = RatingViewController(rootViewController: pageController2)
                    
                    initialViewController.viewControllers?[1] = navigationController2
                    initialViewController.viewControllers?[1].tabBarItem.title = "Rate"
                    initialViewController.viewControllers?[1].tabBarItem.image = UIImage(named: "Rate")
                    
                    window.rootViewController = initialViewController
                    initialViewController.selectedIndex = 1
                    
                    
                    
                    window.makeKeyAndVisible()
                    self.navigationController?.popToRootViewController(animated: true)
                }
                case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}


