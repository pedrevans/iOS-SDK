//
//  DetailViewController.swift
//  AccelerometerExample-Swift
//
//  Created by Grzegorz Krukiewicz-Gacek on 05.01.2015.
//  Copyright (c) 2015 Estimote Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ESTNearableManagerDelegate, ESTTriggerManagerDelegate {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var orientationLabel: UILabel!
    @IBOutlet weak var accelerometerLabel: UILabel!
    
    var nearable:ESTNearable!
    var nearableManager:ESTNearableManager!
    let triggerManager = ESTTriggerManager()
    var lastRssi: Int = 0
    let warmer = "warmer"
    let colder = "colder"
    var warmCold: String = "-"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearableManager = ESTNearableManager()
        nearableManager.delegate = self
        nearableManager .startRangingForIdentifier(nearable.identifier)
        setUpTrigger()
        typeLabel.text = ESTNearableDefinitions.nameForType(nearable.type)
    }
    func setUpTrigger(){
        self.triggerManager.delegate = self
        let rule1 = ESTOrientationRule.orientationEquals(.HorizontalUpsideDown, forNearableType: .Bag)
        let rule2 = ESTMotionRule.motionStateEquals(true, forNearableIdentifier: "5e5e250a298c3366") //chair
        let trigger = ESTTrigger(rules: [rule1, rule2], identifier: "Tom the Trigger")
        self.triggerManager.startMonitoringForTrigger(trigger)
    }
    func triggerManager(manager: ESTTriggerManager, triggerChangedState trigger: ESTTrigger) {
        if trigger.identifier == "Tom the Trigger" && trigger.state {
            print("Tom has moved")
        } else {
            print("TaTa")
        }
    }
    func itsGettingNearer(nearable: ESTNearable) -> Bool {
        print("lastRssi ",lastRssi, "currentRssi", nearable.rssi)
        let ret = nearable.rssi > lastRssi
        lastRssi = nearable.rssi
        return ret
    }
    
    //MARK: - ESTNearableManager delegate
    
    func nearableManager(manager: ESTNearableManager, didRangeNearable nearable: ESTNearable) {
//        temperatureLabel.text = NSString(format: "%.1f°C", nearable.temperature)
        var orientationString:String
        var currSysVer:String = UIDevice().systemVersion
        if !nearable.isMoving {
            switch nearable.orientation {
            case ESTNearableOrientation.Horizontal:
                orientationString = "Sticker is on its back"
            case ESTNearableOrientation.HorizontalUpsideDown:
                orientationString = "Sticker is on its front"
            case ESTNearableOrientation.Vertical:
                orientationString = "Sticker is on its legs"
            case ESTNearableOrientation.VerticalUpsideDown:
                orientationString = "Sticker is on its head"
            case ESTNearableOrientation.LeftSide:
                orientationString = "Sticker is on its left side"
            case ESTNearableOrientation.RightSide:
                orientationString = "Sticker is on its right side"
            case ESTNearableOrientation.Unknown:
                orientationString = "Sticker orientation unknown"
            }
        } else {
            orientationString = "Sticker is moving"
        }
        orientationLabel.text = orientationString
        if nearable.rssi != lastRssi {
            if nearable.rssi > lastRssi {
                warmCold = warmer
            } else if nearable.rssi < lastRssi {
                warmCold = colder
            }
        }
        lastRssi = nearable.rssi
        self.accelerometerLabel.text = String(format: "x axis: %dmG \n y axis: %dmG \n z axis: %dmG \n temp: %.1f°C \n rssi: %d \n zone: %d \n %@ \n",
            nearable.xAcceleration,
            nearable.yAcceleration,
            nearable.zAcceleration,
            nearable.temperature,
            nearable.rssi,
            nearable.zone().rawValue,
            warmCold
        )
    }
}

