//
//  UIColor+Ext.swift
//  VK
//
//  Created by Михаил Киржнер on 21.02.2022.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1),
            alpha: 1.0
        )
    }
}
