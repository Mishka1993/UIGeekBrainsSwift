//
//  ImageView.swift
//  VK
//
//  Created by Екатерина on 12.11.2021.
//

import UIKit

@IBDesignable class ImageView: UIImageView {
    @IBInspectable var shadowColor: UIColor = .black {
            didSet {
                setNeedsDisplay()
            }
        }
    @IBInspectable var shadowRadius: CGFloat = 10 {
            didSet {
                setNeedsDisplay()
            }
        }
    
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.layer.cornerRadius = containerView.frame.width / 2
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = shadowColor.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = shadowRadius
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        containerView.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
