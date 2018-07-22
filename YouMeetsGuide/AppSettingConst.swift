//
//  AppSettingConst.swift
//  MenuSignage
//
//  Created by Ryou on 2016/05/15.
//  Copyright © 2016年 Oak Leaf Project. All rights reserved.
//
import UIKit
import Foundation
struct AppSettingConst {
    
    static let baseColor:UIColor = UIColor(red: 114.0/255.0, green: 142.0/255.0, blue: 157.0/255.0, alpha: 1.0);
    static let baseBackgroundColor:UIColor = UIColor(red: 212.0/255.0, green: 222.0/255.0, blue: 226.0/255.0, alpha: 1.0);
    static let baseLightColor:UIColor = UIColor(red: 162.0/255.0, green: 182.0/255.0, blue: 192.0/255.0, alpha: 1.0);
    static let baseTextColor:UIColor = UIColor(red: 47.0/255.0, green: 87.0/255.0, blue: 109.0/255.0, alpha: 1.0);

    static let baseClearColor:UIColor = UIColor(red: 230.0/255.0, green: 172.0/255.0, blue: 25.0/255.0, alpha: 0.1);
    static let alertColor:UIColor = UIColor(red: 211.0/255.0, green: 56.0/255.0, blue: 28.0/255.0, alpha: 1.0);
    static let dsgBackColor:UIColor = UIColor(red: 55.0/255.0, green: 48.0/255.0, blue: 22.0/255.0, alpha: 1.0);
    
    static let baseGreenColor:UIColor = UIColor(red: 0.098, green: 0.8, blue: 0.098, alpha: 1.0)
    static let titleGreenColor:UIColor = UIColor(red: 0.0, green: 0.529, blue: 0.0, alpha: 1.0)
    static let strongGreenColor:UIColor = UIColor(red: 0.004, green: 0.675, blue: 0.004, alpha: 1.0)
    static let textGreenColor:UIColor = UIColor(red: 0.804, green: 0.969, blue: 0.804, alpha: 1.0)

    
    static let hiwaMoegiColor:UIColor = UIColor(red: 130.0/255.0, green: 174.0/255.0, blue: 70.0/255.0, alpha: 1.0);
    static let natsumusiColor:UIColor = UIColor(red: 206.0/255.0, green: 228.0/255.0, blue: 174.0/255.0, alpha: 1.0);
    static let natsumusiAlphaColor:UIColor = UIColor(red: 206.0/255.0, green: 228.0/255.0, blue: 174.0/255.0, alpha: 0.7);
    
    static let baseTitleFont:UIFont = UIFont.boldSystemFont(ofSize: 25.0);
    static let baseFont:UIFont = UIFont.systemFont(ofSize: 18.0);
    static let AmericanTypewriterLightFont:UIFont? = UIFont(name: "AmericanTypewriter-Light", size: 30.0);
    static let AmericanTypewriterBoldFont:UIFont? = UIFont(name: "AmericanTypewriter-Bold", size: 30.0);
    static let AvenirNextUltraLightFont:UIFont? = UIFont(name: "AvenirNext-UltraLight", size: 30.0);
    static let AvenirNextFont:UIFont? = UIFont(name: "AvenirNext-Regular", size: 30.0);
    
    
    static let OneDayTimeInterval:TimeInterval = 24.0*60.0*60.0;
    static let OneHourTimeInterval:TimeInterval = 60.0*60.0;
    static let HalfDayTimeInterval:TimeInterval = 12.0*60.0*60.0;
    static let QuarterDayTimeInterval:TimeInterval = 6.0*60.0*60.0;
    
    static let NotificationNameUpdateItemList:String = "update-item-list";
    static let NotificationNameImagePicker:String = "didtouch-image-picker";
    static let NotificationNameFont:String = "didtouch-font";
    static let NotificationNameContact:String = "didtouch-contact";
    static let NotificationNameViewMode:String = "didtouch-view-mode";
    static let NotificationNameChangeViewMode:String = "didtouch-change-view-mode";
    static let NotificationNameRotationLeft:String = "didtouch-rotation-left";
    static let NotificationNameRotationRight:String = "didtouch-rotation-right";
    static let NotificationNameRotationFront:String = "didtouch-rotation-front";
    static let NotificationNameRotationRear:String = "didtouch-rotation-rear";

    
    static let KeyTimeOfAnimation:String = "time-of-animation";
    static let KeyNumOfContents:String = "num-of-contents";
    static let KeyTextColor:String = "text-color";

    static let KeyProjecter:String = "projecter";
    
    static let shadowOffset:CGSize = CGSize(width: 0.0, height: 2.0);
    static let shadowRadius:CGFloat = 3.5;
    static let shadowOpacity:Float = 0.4;
    static let menuViewSizeH:CGFloat = 60.0;
    static let isVolunteer:Bool = false;
    enum SpotType:Int {
        case none = 0
        case spot = 1
        case volunteer = 2
        case toilet = 3
        case restrunt = 4
        case hospital = 5
        case aed = 6
        case wifi = 7
    }
}
