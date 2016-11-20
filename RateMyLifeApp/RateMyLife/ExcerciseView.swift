//
//  OutdoorActivity.swift
//  RateMyLife
//
//  Created by Monster on 2016-11-19.
//  Copyright © 2016 Monster. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import CircleSlider

class ExcerciseView : CommonView{
    
    var circleSlider : CircleSlider!
    private var timer: Timer?
    private var progressValue: Float = 0
    let storage = HKHealthStore()
    var step : Int?
    var stepLabel : UILabel!
    var distanceLabel : UILabel!
    var distance : Double?
    
    lazy var logoImage: UIImageView! = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RateMyExercise")
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width , height: 200 )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var stepDisplay : UIView!
    
    var stepView: UIView!

    override init(frame: CGRect, commonViewController : CommonViewController) {
        super.init(frame: frame, commonViewController: commonViewController)
        
        self.addSubview(logoImage)
        
        let view = UIView(frame : CGRect(x: 5, y: 150, width: self.frame.width - 10, height: 80))
        view.layer.borderWidth = 2
        view.layer.borderColor = AppColor.dividerColor2.cgColor
        view.layer.cornerRadius = 20
        view.backgroundColor = AppColor.lightOrange
        
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: self.frame.width / 2,height: 80))
        label.text = "Steps:"
        label.font = UIFont(name: "breipfont", size: 50)
        label.textColor = UIColor.white
        stepLabel = UILabel(frame: CGRect(x: self.frame.width / 2 + 35, y: 10, width : 200, height: 80))
        stepLabel.text = "0"
        stepLabel.font = UIFont(name: "breipfont", size: 50)
        stepLabel.textColor = UIColor.white
        view.addSubview(label)
        view.addSubview(stepLabel)
        stepDisplay = view
        self.addSubview(stepDisplay)
        
        
        let view2 = UIView(frame : CGRect(x: 5, y: 270, width: self.frame.width - 10, height: 80))
        view2.layer.borderWidth = 2
        view2.layer.borderColor = AppColor.dividerColor2.cgColor
        view2.layer.cornerRadius = 20
        view2.backgroundColor = AppColor.lightOrange
        
        let label2 = UILabel(frame: CGRect(x: 40, y: 10, width: self.frame.width / 2,height: 80))
        label2.text = "Distance:"
        label2.font = UIFont(name: "breipfont", size: 50)
        label2.textColor = UIColor.white
        distanceLabel = UILabel(frame: CGRect(x: self.frame.width / 2 + 40, y: 10, width : 200, height: 80))
        distanceLabel.text = "0"
        distanceLabel.font = UIFont(name: "breipfont", size: 50)
        distanceLabel.textColor = UIColor.white
        view2.addSubview(label2)
        view2.addSubview(distanceLabel)
        self.addSubview(view2)
        
        
        
        initStepView()
        
        self.addSubview(backButton)
        
        authorizeHealthKit { (success : Bool, error : NSError?) in
            if success{
                self.retrieveStepCount()
                self.retrieveDistanceCount()
                //self.addSubview(view)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initStepView(){
        let view = UIView()
        circleSlider = CircleSlider(frame: CGRect(x: self.frame.width / 2 - 100, y: 170, width: 200, height: 200) , options: [.barColor(UIColor(red: 255/255, green: 190/255, blue: 190/255, alpha: 0.3)),
                                                                                                                             .trackingColor(AppColor.lightOrange),
                                                                                                                             .barWidth(20),
                                                                                                                             .sliderEnabled(false)])
        
        //circleSlider?.addTarget(self, action: Selector("valueChange:"), forControlEvents: .ValueChanged)
        view.frame = CGRect(x: 0, y: 200, width: self.frame.width, height: 300)
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = AppColor.themeColor
        view.addSubview(circleSlider)
        self.progressValue = 0
        self.stepView = view
        self.addSubview(stepView)
        self.timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
    }

    func fire(timer: Timer) {
        self.progressValue += 0.5
        if self.progressValue > 60 {
            self.timer?.invalidate()
            self.timer = nil
            self.progressValue = 60
        }
        self.circleSlider.value = self.progressValue
    }

    func authorizeHealthKit(completion: ((_ success:Bool, _ error:NSError?) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
            ]
        
        // 2. Set the types you want to write to HK Store
//        let healthKitTypesToWrite = Set(arrayLiteral:[
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned),
//            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning),
//            HKQuantityType.workoutType()
//            ])
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            _ = NSError(domain: "com.raywenderlich.tutorials.healthkit", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
             //   completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization
        storage.requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion?(success,error as NSError?)
            }
        }
    }
    
    func retrieveStepCount() -> Void {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        //   Get the start of the day
        let date = NSDate()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date as Date)
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        let oneDayAgo = cal.date(byAdding: .day, value: -1, to: Date())
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval as DateComponents)
        
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            
            if let myResults = results{
                myResults.enumerateStatistics(from: oneDayAgo! as Date, to: date as Date) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        
                        self.step = Int(steps)
                        print("Steps = \(steps)")
                        
                        DispatchQueue.main.async {
                            self.stepLabel.text = String(format: "%.0f", steps) // also does not work
                        }
                        
                        
                    }
                }
            }
            
            
        }

        storage.execute(query)
    }
    
    func retrieveDistanceCount() -> Void {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        
        //   Get the start of the day
        let date = NSDate()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date as Date)
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        let oneDayAgo = cal.date(byAdding: .day, value: -1, to: Date())
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval as DateComponents)
        
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            
            if let myResults = results{
                myResults.enumerateStatistics(from: oneDayAgo! as Date, to: date as Date) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        let distance = quantity.doubleValue(for: HKUnit.meter())
                        self.distance = distance
                        print("Distance = \(distance)")
                    
                        DispatchQueue.main.async {
                            self.distanceLabel.text = String(format: "%.1f", distance) // also does not work
                        }
                        
                        
                    }
                }
            }
            
            
        }
        
        storage.execute(query)
    }
    
    
}
