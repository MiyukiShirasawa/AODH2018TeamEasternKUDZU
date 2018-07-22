//
//  SelectLanguageVC.swift
//  YouMeetsGuide
//
//  Created by Ryou on 2018/07/21.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit

class SelectLanguageVC: UIViewController {
    let mainScrollView:UIScrollView = UIScrollView()
    static var languageData:NSDictionary! = {
        let path = Bundle.main.path(forResource: "Language", ofType: "plist") as! String
        let categoryInfo = NSDictionary(contentsOfFile: path)
        return categoryInfo!
    }()
    var btnArray:Array<MenuButton> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        self.edgesForExtendedLayout = []
        mainScrollView.frame = self.view.bounds
        self.view.addSubview(mainScrollView)
        let btnSize:CGFloat = self.view.frame.width * 0.5
        let margin:CGFloat = 30.0
        var posX:CGFloat = self.view.frame.width * 0.5 - btnSize * 0.5
        var delay:CGFloat = 0.5
        var posY:CGFloat = 40.0
        var tagNo:Int = 1
        for lang in SelectLanguageVC.languageData.allValues as! [Dictionary<String, Any>] {
            let langBtn = MenuButton(frame: CGRect(x: posX, y: posY, width: btnSize, height: btnSize))
            let imageName = lang["image-path"] as! String
            let name = lang["name"] as! String
            langBtn.showButton(position: langBtn.frame.origin, duration: 0.5, delay: TimeInterval(delay))
            langBtn.iconView.image = UIImage(named: imageName)
            langBtn.iconView.contentMode = .scaleAspectFill
            langBtn.iconView.layer.cornerRadius = btnSize * 0.5
            langBtn.title.text = name
            langBtn.tag = tagNo
            self.mainScrollView.addSubview(langBtn)
            langBtn.addTarget(self, action: #selector(self.didTouchLanguage(btn:)), for: .touchUpInside)
            delay += 0.5
            tagNo += 1
            posY += btnSize + margin
        }
        self.mainScrollView.contentSize = CGSize(width: self.view.frame.width, height: posY + btnSize + margin)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func didTouchLanguage(btn:UIButton){
        LocationManager.shared.playSound(fileName: "payment_success")
        let uid = NSUUID().uuidString
        UserDefaults.standard.set(true, forKey: "firstboot")
        if UserDefaults.standard.object(forKey: "uuid") == nil {
            UserDefaults.standard.set(uid, forKey: "uuid")
        }
        UserDefaults.standard.synchronize()
        LocationManager.shared.setup()
        self.navigationController?.popViewController(animated: true)
    }

}
