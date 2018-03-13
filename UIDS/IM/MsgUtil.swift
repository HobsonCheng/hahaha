//
//  MsgUtil.swift
//  UIDS
//
//  Created by one2much on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


private let MsgUtilShared = MsgUtil()

class MsgUtil: NSObject {

    static var shared : MsgUtil {
        return MsgUtilShared
    }
    
    func showUtil() {
      
        let suspen = BSuspensionView(frame: .zero)
        suspen.initBt(frame: .zero, delegate: self)
        
        let appwindow = UIApplication.shared.delegate?.window
        appwindow??.addSubview(suspen)
    
    }
}


extension MsgUtil:BSuspensionViewDelegate{
    
    
    func suspensionViewClick(view: BSuspensionView) {
        
    }

}

//MARK - 生成视图

protocol BSuspensionViewDelegate {
    
    //点击按钮
    func suspensionViewClick(view: BSuspensionView)
    
}

enum BSuspensionViewLeanType {
    case Horizontal//左右
    case EachSide//全局
}


class BSuspensionView: UIButton {
    
    private var delegate: BSuspensionViewDelegate?
    
    var leanType: BSuspensionViewLeanType!
    
    
    func initBt(frame: CGRect, delegate: BSuspensionViewDelegate){
        self.delegate = delegate
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.red
        self.alpha = 0.8
        
        self.setImage(UIImage.init(named: "2.png"), for: UIControlState.normal)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(changeLocation(p:)))
        pan.delaysTouchesBegan = true
        self.addGestureRecognizer(pan)
        self.addTarget(self, action: #selector(click), for: UIControlEvents.touchUpInside)
    }
    
    
    
    
    @objc func changeLocation(p:UIPanGestureRecognizer){
        
        let appwindow = UIApplication.shared.delegate?.window
        let panPoint = p.location(in: appwindow!)
        
        if (p.state == UIGestureRecognizerState.began){
            
            self.alpha = 1
        }else if (p.state == UIGestureRecognizerState.changed){
            
            
        }else if (p.state == UIGestureRecognizerState.ended || p.state == UIGestureRecognizerState.cancelled) {
            
            self.alpha = 0.8
            let touchWidth = self.width
            let touchHeight = self.height
            let screenWith = kScreenW
            let screenHeight = kScreenH
            
            let left:Float = Float(fabs(panPoint.x))
            let right:Float = fabs(Float(screenWith) - left)
            let top:Float = Float(fabs(panPoint.y))
            let bottom:Float = fabs(Float(screenHeight) - top)
            
            var minSpace: Float = 0.0
            
            if self.leanType == BSuspensionViewLeanType.Horizontal {
                minSpace = Float(min(left, right))
            }else {
                minSpace = Float(min(Float(min(Float(min(top, left)), bottom)), right))
            }
            
            let newCenter: CGPoint!
            let targetY:CGFloat!
            
            //校正Y
            if panPoint.y < 15 + touchHeight/2.0{
                targetY = 15 + touchHeight/2.0
            }else if panPoint.y > (screenHeight - touchHeight / 2.0 - 15) {
                targetY = screenHeight - touchHeight / 2.0 - 15
            }else{
                targetY = panPoint.y
            }
            
            if minSpace == left {
                newCenter = CGPoint(x: touchHeight/3, y: targetY)
            }else if minSpace == right {
                newCenter = CGPoint(x: screenWith - touchHeight / 3, y: targetY)
            }else if minSpace == top {
                newCenter = CGPoint(x: panPoint.x, y: touchWidth / 3)
            }else if minSpace == bottom {
                newCenter = CGPoint(x: panPoint.x, y: screenHeight - touchWidth / 3)

            }
            
            UIView.animate(withDuration: 0.25, animations: {
                //[ZYSuspensionManager windowForKey:self.md5Key].center = newCenter;
            })
        }
    }
    
    @objc func click(){
        self.delegate?.suspensionViewClick(view: self)
    }
    
}
