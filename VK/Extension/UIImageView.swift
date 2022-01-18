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
    
}
