//
//  SecondViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UIScrollViewDelegate {
    var scrollView : UIScrollView!
    var profileView : UIView!
    var userProfileImage : UIImageView!
    var userName : String?
    var user : User?
    var imageDownloader : ImageDownloader?
    
    var tdView : UIButton!
    var newsView :UIButton!
    var dealsView :UIButton!
    var findFriendView : UIButton!
    var rateUs : UIButton!
    var aboutUs : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = UserDefaults.standard

        
        user = User(userName: defaults.string(forKey: defaultsKeys.keyOne)!,
                    userID: defaults.string(forKey: defaultsKeys.keyTwo)!)
        
        let url = "http://graph.facebook.com/" + (user?.userID)! + "/picture?type=square"
        imageDownloader = ImageDownloader(user: user!, url: url)
        imageDownloader?.downloadImg()
        
        //print("userName : \(userName)")
        self.navigationController?.navigationBar.isHidden = true
        configureNavigationBar()
        configureView()
        self.view.backgroundColor = AppColor.dividerColor2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureNavigationBar(){
        let newNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        let newNavigationItem = UINavigationItem()
        newNavigationBar.barTintColor = UIColor.white
        newNavigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 0.23, green: 0.55, blue: 0.92, alpha: 1.0), NSFontAttributeName : UIFont.systemFont(ofSize: 25)]
        newNavigationItem.title = "Account"
        newNavigationBar.setItems([newNavigationItem], animated: false)
        self.view.addSubview(newNavigationBar)
    }
    
    func configureView(){
         scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        scrollView.contentSize = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 800).size
        
        let profileView = user?.createButtonView(CGRect(x:0, y: 10, width: self.view.frame.width, height: 60))
        
        self.scrollView.addSubview(profileView!)
        
        let leaderboard = UIButton(frame: CGRect(x: 15, y: (profileView?.frame.maxY)! + 10, width: self.view.frame.width / 2 - 18, height: 150))
        
        leaderboard.setImage(UIImage(named: "champion"), for: .normal)
//        leaderboard.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 60, 40)
//        leaderboard.contentVerticalAlignment = .top
//        leaderboard.contentHorizontalAlignment = .center
        leaderboard.layer.cornerRadius = 15
        leaderboard.layer.borderWidth = 2
        leaderboard.layer.borderColor = AppColor.dividerColor3.cgColor
//        leaderboard.setTitle("Leader Board", for: .normal)
//        leaderboard.titleEdgeInsets = UIEdgeInsetsMake(100, 0, 0, 0)
//        leaderboard.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
//        leaderboard.setTitleColor(UIColor.black, for: .normal)
        leaderboard.backgroundColor = UIColor.white
        
        self.scrollView.addSubview(leaderboard)
        
        let notification = UIButton(frame: CGRect(x: self.view.frame.width / 2 + 15, y: (profileView?.frame.maxY)! + 10, width: self.view.frame.width / 2 - 25, height: 150))
        notification.layer.cornerRadius = 15
        notification.layer.borderWidth = 2
        notification.setImage(UIImage(named: "notification"), for: .normal)
        notification.layer.borderColor = AppColor.dividerColor3.cgColor
        notification.backgroundColor = UIColor.white
        
        self.scrollView.addSubview(notification)
        self.scrollView.addSubview(leaderboard)
        
        
        
        tdView = createButtonView(frame: CGRect(x:0, y: leaderboard.frame.maxY + 25, width: self.view.frame.width, height: 60), imageName: "td", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "Connect TD Insurance Account", textFrame: CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 40,height: 50))
        
        let label1 = UILabel(frame : CGRect(x:0, y:tdView.frame.minY - 13, width : self.view.frame.width, height: 10))
        label1.textAlignment = .left
        label1.textColor = UIColor.gray
        label1.text = "Financial:"
        label1.font = UIFont(name: "Teen-Bold", size: 15)
        self.scrollView.addSubview(label1)
        
        newsView = createButtonView(frame: CGRect(x:0, y: tdView.frame.maxY - 1, width: self.view.frame.width, height: 60), imageName: "news", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "View Financial News", textFrame:CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 70, height: 50))
        dealsView = createButtonView(frame: CGRect(x:0, y: newsView.frame.maxY - 1, width: self.view.frame.width, height: 60), imageName: "deals", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "View Financial Deals", textFrame: CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 70, height: 50))
        

        
        findFriendView = createButtonView(frame: CGRect(x: 0, y: dealsView.frame.maxY + 25, width: self.view.frame.width, height: 60), imageName: "friend", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "Find Friends On RateMyLife", textFrame: CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 70, height: 50))
        
        let label2 = UILabel(frame : CGRect(x:0, y:findFriendView.frame.minY - 13, width : self.view.frame.width, height: 10))
        label2.textAlignment = .left
        label2.textColor = UIColor.gray
        label2.text = "Other:"
        label2.font = UIFont(name: "Teen-Bold", size: 15)
        self.scrollView.addSubview(label2)
        
        
        rateUs = createButtonView(frame: CGRect(x: 0, y: findFriendView.frame.maxY - 1, width: self.view.frame.width, height: 60), imageName: "rateUs", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "Rate Us On AppStore", textFrame: CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 70, height: 50))
        aboutUs = createButtonView(frame: CGRect(x: 0, y: rateUs.frame.maxY - 1, width: self.view.frame.width, height: 60), imageName: "aboutUs", imageFrame: CGRect(x:10, y: 10, width : 40, height: 40 ), text: "About Us", textFrame: CGRect(x: 70 , y: 5, width: self.view.frame.size.width - 70, height: 50))
        
        
        let label3 = UILabel(frame : CGRect(x:0, y:aboutUs.frame.maxY + 15, width : self.view.frame.width, height: 40))
        label3.textAlignment = .left
        label3.textColor = UIColor.gray
        label3.numberOfLines = 3
        label3.text = "RateMyLife @2016"
        label3.font = UIFont(name: "Teen-Bold", size: 25)
        self.scrollView.addSubview(label3)
        
        self.view.addSubview(scrollView)
    }
    
    func createButtonView(frame : CGRect, imageName : String, imageFrame : CGRect, text: String, textFrame: CGRect) -> UIButton{
        let button = UIButton(frame: frame)
        button.layer.borderWidth = 2
        button.layer.borderColor = AppColor.dividerColor3.cgColor
        button.backgroundColor = UIColor.white
        
        let img = UIImageView(frame: imageFrame)
        img.layer.cornerRadius = 10
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        img.image = UIImage(named : imageName)
        
        button.addSubview(img)
        
        let titleLabel = UILabel(frame: textFrame)
        titleLabel.text = text
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "Teen-Bold", size: 20)
        button.addSubview(titleLabel)
        self.scrollView.addSubview(button)
        return button
    }

}

class ImageDownloader{
    var user : User!
    var shutDownRequest : Bool = false;
    var url : URL!
    init(user : User, url : String){
        self.user = user
        self.url = URL(string : url)
    }
    
    func downloadImg(){
        //let request = NSMutableURLRequest(url: url)
        //print(request)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                if !self.shutDownRequest{
                    self.user.userProfileImage = image
                }
            }
            }.resume()
    }
    
}


