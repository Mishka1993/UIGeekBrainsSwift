//
//  NewsModel.swift
//  VK
//
//  Created by Екатерина on 17.11.2021.
//

import UIKit

struct Post {
    var group: groupModel
    var descriptionPost: String?
    var imagePost: UIImage?
    var isLiked: Bool
    var likes: Int
}
