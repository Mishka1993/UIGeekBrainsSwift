//
//  UIViewClip.swift
//  VK
//
//  Created by Михаил Киржнер on 08.02.2022.
//

import Foundation

import UIKit

extension UIView {
    func clip(
        cornerRadius: CGFloat = 50.0,
        borderWidth: CGFloat = 1.0,
        borderColor: CGColor = UIColor.lightGray.cgColor
    ) {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}

extension UIView {
    func addShadow(
        cornerRadius: CGFloat = 50.0,
        shadowColor: CGColor = UIColor.lightGray.cgColor,
        shadowRadius: CGFloat = 5.0,
        shadowOpacity: Float = 0.6
    ) {
        let layer = self.layer
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
}
