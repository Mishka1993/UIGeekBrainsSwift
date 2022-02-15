//
//  GroupModel.swift
//  VK
//
//  Created by Екатерина on 11.11.2021.
//

import Foundation
import UIKit

struct groupModel{
    var nameGroup: String
    var imageGroup: UIImage?
    var descrip: String?
    
    init(nameGroup: String, imageGroup: UIImage?, description: String?){
        self.nameGroup = nameGroup
        self.imageGroup = imageGroup
        self.descrip = description
    }
    init(nameGroup: String, imageGroup: UIImage?){
        self.nameGroup = nameGroup
        self.imageGroup = imageGroup
    }
    
}
