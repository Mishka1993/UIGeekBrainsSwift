//
//  UIImage.swift
//  VkClient
//
//  Created by Alexander Fomin on 13.01.2021.
//

import UIKit


extension UIImage {
    func getCropRatio() -> CGFloat {
        return  CGFloat( self.size.width / self.size.height )
    }
}
