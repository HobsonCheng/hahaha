//
//  SwipImgAreaImagePageControl.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Foundation

class SwipImgAreaImagePageControl: UIPageControl {

    open var dotInActiveImage: UIImage = UIImage(named: "lldotInActive.png", in: Bundle(for: SwipImgAreaView.self), compatibleWith: nil)!
    open var dotActiveImage: UIImage = UIImage(named: "lldotActive.png", in: Bundle(for: SwipImgAreaView.self), compatibleWith: nil)!
    
    override open var numberOfPages: Int {
        didSet {
            updateDots()
        }
    }
    
    override open var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    
    func updateDots() {
        var i = 0
        for view in self.subviews {
            var imageView = self.imageView(forSubview: view)
            if imageView == nil {
                if i == 0 {
                    imageView = UIImageView(image: dotInActiveImage)
                } else {
                    imageView = UIImageView(image: dotActiveImage)
                }
                imageView!.center = view.center
                imageView?.frame = CGRect.init(x: view.frame.origin.x, y: view.frame.origin.y+2, width: 8, height: 8)
                view.addSubview(imageView!)
                view.clipsToBounds = false
            }
            
            if i == self.currentPage {
                imageView!.image = dotInActiveImage
            } else {
                imageView!.image = dotActiveImage
            }
            i += 1
        }
    }
    
    fileprivate func imageView(forSubview view: UIView) -> UIImageView? {
        var dot: UIImageView?
        if let dotImageView = view as? UIImageView {
            dot = dotImageView
        } else {
            for foundView in view.subviews {
                if let imageView = foundView as? UIImageView {
                    dot = imageView
                    break
                }
            }
        }
        return dot
    }

}
