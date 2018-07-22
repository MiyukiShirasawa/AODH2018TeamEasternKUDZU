//
//  PointAnnotation.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/22.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit
import MapKit
class PointAnnotation: MKPointAnnotation {
    var tag:Int! = 0
    var type:AppSettingConst.SpotType! = AppSettingConst.SpotType.none
}
