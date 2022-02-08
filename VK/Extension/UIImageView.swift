//
//  UIImageView.swift
//  VK
//
//  Created by Михаил Киржнер on 18.01.2022.
//

import Foundation
import UIKit
import RealmSwift

extension UIImageView {
    
    func load(url: URL, completion: @escaping (UIImage)->()) {
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data){
                self.image = image
                completion(image)
            }
        }
    }
    func resizeAndSpringAnimate() {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 1,
                    delay: 0,
                    usingSpringWithDamping: 0.3,
                    initialSpringVelocity: 10,
                    options: .curveEaseInOut,
                    animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                )
            }
        )
    }
}
