//
//  MenuButton.swift
//  QuizTag
//
//  Created by Ryou on 2018/04/10.
//  Copyright © 2018年 Ryou. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    var iconView:UIImageView! = UIImageView()
    var title:UILabel! = UILabel()
    private var baseView:UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let size:CGFloat = frame.width
        baseView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size, height: size))
        baseView.layer.cornerRadius = size * 0.5
        baseView.layer.shadowOffset = AppSettingConst.shadowOffset
        baseView.layer.shadowRadius = AppSettingConst.shadowRadius
        baseView.layer.shadowOpacity = AppSettingConst.shadowOpacity
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.backgroundColor = UIColor.clear
        baseView.isUserInteractionEnabled = false
        self.addSubview(baseView)
        let iconSize:CGFloat = size * 0.4
        iconView!.frame = CGRect(x: size * 0.5 - iconSize * 0.5, y: size * 0.5 - iconSize * 0.5, width: iconSize, height: iconSize)
        iconView.isUserInteractionEnabled = false
        baseView.addSubview(iconView)
        title.frame = CGRect(x: 0.0, y: frame.height * 0.8, width: frame.width, height: frame.height * 0.2)
        title.font = UIFont.boldSystemFont(ofSize: title.frame.height * 0.7)
        title.adjustsFontSizeToFitWidth = true
        title.textColor = AppSettingConst.baseTextColor
        title.textAlignment = .center
        self.addSubview(title)
        self.alpha = 0.0
        
        self.addTarget(self, action: #selector(self.touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchUp), for: [.touchUpInside,.touchUpOutside])

    }
    
    @objc func touchUp() {
        let shadowColorAnimation:CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        shadowColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        shadowColorAnimation.fromValue = UIColor.clear.cgColor
        shadowColorAnimation.toValue = UIColor.black.cgColor
        
        let positionAnimation:CABasicAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = self.baseView.layer.position
        var position1 = self.baseView.layer.position
        position1.y -= AppSettingConst.shadowOffset.height
        positionAnimation.toValue = position1
        
        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.setValue("menu-animation", forKey: "animationName2")
        animationGroup.animations = [shadowColorAnimation]
        animationGroup.duration = 0.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        self.baseView.layer.add(animationGroup, forKey: "menu-animation")
    }
    @objc func touchDown(){
        let shadowColorAnimation:CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        shadowColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        shadowColorAnimation.fromValue = UIColor.black.cgColor
        shadowColorAnimation.toValue = UIColor.clear.cgColor
        
        let positionAnimation:CABasicAnimation = CABasicAnimation(keyPath: "position")
        var position1 = self.baseView.layer.position
        position1.y -= AppSettingConst.shadowOffset.height
        positionAnimation.toValue = self.baseView.layer.position
        positionAnimation.fromValue = position1

        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.setValue("menu-animation", forKey: "animationName2")
        animationGroup.animations = [shadowColorAnimation]
        animationGroup.duration = 0.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        self.baseView.layer.add(animationGroup, forKey: "menu-animation")
    }
    func hiddenButton(){
        UIView.animate(withDuration: 0.25) {
            self.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
            self.alpha = 0.0
        }
    }
    func showButton(position:CGPoint, duration:TimeInterval, delay:TimeInterval){
        self.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
        }) { (finish) in
            if self.tag != 1 {
                // sound
            }

            UIView.animate(withDuration: 0.5, animations: {
                var frame = self.frame
                frame.origin = position
                self.frame = frame

            }, completion: { (finish) in
                
            })
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely aff#imageLiteral(resourceName: "sound_off.png")#imageLiteral(resourceName: "sound_on.png")ects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
