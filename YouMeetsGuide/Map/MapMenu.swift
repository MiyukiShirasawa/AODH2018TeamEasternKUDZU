//
//  MapMenu.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/21.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit

class MapMenu: UIView {

    let mainScrollView:UIScrollView = UIScrollView()
    let categoryScrollView:UIScrollView = UIScrollView()
    var mainContentsArray:Array<UIButton> = Array()
    var contentsInfoArray:Array<NSDictionary> = Array()
    var categoryArray:Array<UIButton> = Array()
    func setup(){
        mainScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height * 0.75)
        categoryScrollView.frame = CGRect(x: 0.0, y: self.frame.height * 0.75, width: self.frame.width, height: self.frame.height * 0.25)
        self.addSubview(mainScrollView)
        self.addSubview(categoryScrollView)
        
    }
    func updateMainScroll(){
        for view in mainScrollView.subviews {
            view.removeFromSuperview()
        }
        var posX:CGFloat = 0.0
        for info in contentsInfoArray {
            let imagePath = info.object(forKey: "image-path") as! String
            let contentButton = UIButton()
            contentButton.frame = CGRect(x: posX, y: 0.0, width: self.frame.width, height: self.frame.height * 0.75)
            contentButton.setImage(UIImage(named: "name"), for: .normal)
            posX += self.frame.width
            
        }
    }
    
}
