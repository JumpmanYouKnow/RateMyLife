//
//  FoodViewController.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit

let clarifaiID = "wt1qLZohGADLmX8Sa3x1vk9AfnK3OHU-MC4z_cgk"
let clarifaiSecret = "ORIB3HZ7pkYFPadGDZKWPtI1selDA3yz17y5yab5"

class FoodView : CommonView, UIImagePickerControllerDelegate , UINavigationControllerDelegate, UIScrollViewDelegate{
    
    var scrollView : UIScrollView!
    var selectedImage : UIImage?
    var clarifai: Clarifai!
    var subview : [UIView] = [UIView]()
    var tagResultsList: TagResultsList!
    
    lazy var logoImage: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RateMyfood")
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width , height: 180 )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cameraButton: UIButton! = {
        let button = UIButton()
        button.frame = CGRect(x: self.frame.width / 2 - 65, y: 200, width: 130, height: 130)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Camera Button"), for: UIControlState())
        button.addTarget(self, action: #selector(self.cameraAcessAction), for: .touchUpInside)
        
        return button
    }()
    
    
    lazy var linkButton: UIButton! = {
        let button = UIButton()
        button.frame = CGRect(x: self.frame.width / 2 - 65, y: 400, width: 130, height: 130)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Link Button"), for: UIControlState())
        button.addTarget(self, action: #selector(self.libraryAcessAction), for: .touchUpInside)
        return button
    }()
    
    var loadingLabel: UILabel!
    var imagePreviewView: UIImageView!
    
    var parallexFactor: CGFloat = 2.0
    var scrollOffset: CGFloat = 0 {
        didSet {
            moveImage()
        }
    }
    var imgHeight: CGFloat = 0{
        didSet {
            moveImage()
        }
    }
    
    
    override init(frame: CGRect, commonViewController : CommonViewController) {
        super.init(frame: frame, commonViewController: commonViewController)
        
        clarifai = Clarifai(clientID: clarifaiID, clientSecret: clarifaiSecret)
        imgHeight = self.frame.height / 2
        
        self.addSubview(logoImage)
        self.addSubview(linkButton)
        self.addSubview(cameraButton)
        self.addSubview(backButton)
        subview = self.subviews
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotateLoadSpinner(_ spinner: UIImageView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions(), animations: {() -> Void in
            spinner.transform = spinner.transform.rotated(by: CGFloat(M_PI_2))
        }, completion: {(finished: Bool) -> Void in
            self.rotateLoadSpinner(spinner)
        })
    }
    
    func moveImage() {
        let imageOffset = CGFloat(0.0)
        let imageHeight = (scrollOffset > 0) ? self.imgHeight : self.imgHeight - scrollOffset
        // print("imageOffset: " + String(imageOffset))
        // print("imageHeight: " + String(imageHeight))
        self.imagePreviewView.frame = CGRect(x: 0, y: -imageHeight + imageOffset, width: self.frame.width, height: imageHeight)
    }
    
    func cameraAcessAction(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        commonViewController.present(pickerController, animated: true, completion: nil)
    }
    
    func libraryAcessAction(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        commonViewController.present(pickerController, animated: true, completion: nil)

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
        selectedImage = image
        recognize()
//        let recognizerViewController = RecognizerViewController(image: image, clarifai: clarifai!)
//        present(recognizerViewController, animated: true, completion: nil)
    }
    
    func recognize(){
        discardViews()
        
        let list = TagResultsList()
        list.translatesAutoresizingMaskIntoConstraints = false
        tagResultsList = list
        
        let label = PaddedLabel(top: 15, left: 75, bottom: 15, right: 45, frame: CGRect(x: self.frame.width / 2 - 110, y: 20, width: 220, height : 80))
        label.text = "Analyzing..."
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        label.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        //label.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.sizeToFit()
        
        let spinner = UIImageView(frame: CGRect(x: 32, y: 25, width: 30, height: 30))
        spinner.image = UIImage(named: "Load Spinner")
        label.addSubview(spinner)
        loadingLabel = label
        
        self.rotateLoadSpinner(spinner)
        
        let backButton = UIButton(frame: CGRect(x: 5 , y: 5, width: 50, height: 50))
        backButton.layer.cornerRadius = 0.5 * backButton.bounds.size.width
        backButton.clipsToBounds = true
        backButton.setImage(UIImage(named: "back_normal"), for: .normal)
        backButton.setImage(UIImage(named: "back_pressed"), for: .highlighted)
        backButton.layer.borderWidth = 1.5
        backButton.layer.borderColor = AppColor.dividerColor.cgColor
        backButton.backgroundColor = UIColor.white
        backButton.addTarget(self, action: #selector(backButtonFromRecognizerAction), for: .touchUpInside)
        
        imagePreviewView = UIImageView(frame: CGRect(x: 0, y: -imgHeight, width: self.frame.width, height: imgHeight))
        imagePreviewView.contentMode = .scaleAspectFill
        imagePreviewView.clipsToBounds = true
        imagePreviewView.image = selectedImage
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        scrollView.contentInset = UIEdgeInsets(top: imgHeight, left: 0, bottom: 0, right: 0)
        
        scrollView.contentSize = CGRect(x: 0, y: 0, width: self.frame.width, height: 800).size
        
        scrollView.addSubview(imagePreviewView)
        self.addSubview(scrollView)
        self.addSubview(backButton)
        
        scrollView.addSubview(loadingLabel)
        scrollView.addSubview(list)
        
        if let image = selectedImage {
            imagePreviewView.image = image
            
            clarifai.recognize(image: [image], completion: { (response, error) in
                if error != nil {
                    return print(error ?? 0)
                }
                
                var labels: Array<String> = []
                for tag in response!.results[0].tags! {
                    //labels.append(tag.classLabel)
                    let combineString = "Class: \(tag.classLabel)" + " Probability: \(tag.probability) \n"
                    labels.append(combineString)
                }
                
                self.loadingLabel.isHidden = true
                self.tagResultsList.resultItems = labels
                self.tagResultsList.reloadData()
                self.tagResultsList.isHidden = false
                
                //self.setupResultsView(labels)
            })
        }
    }
    
    func backButtonFromRecognizerAction(){
        self.scrollView.removeFromSuperview()
        addViews()
    }
    
    func discardViews(){
        for view in subview{
            view.removeFromSuperview()
        }
    }
    func addViews(){
        for view in subview{
            self.addSubview(view)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollOffset = scrollView.contentOffset.y + imgHeight
    }
}

class PaddedLabel: UILabel {
    
    var topInset: CGFloat!
    var leftInset: CGFloat!
    var bottomInset: CGFloat!
    var rightInset: CGFloat!
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat, frame : CGRect) {
        super.init(frame: frame)
        
        topInset = top
        leftInset = left
        bottomInset = bottom
        rightInset = right
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class TagResultsList: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var resultItems: Array<String> = []
    
    init() {
        super.init(frame: CGRect(x: 5, y: 5, width: 500, height: 500), style: .plain)
        
        isHidden = true
        separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        delegate = self
        dataSource = self
        self.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = resultItems[indexPath.row]
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


