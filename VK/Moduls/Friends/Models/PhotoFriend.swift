//
//  PhotoFriend.swift
//  VK
//
//  Created by Екатерина on 23.12.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

class PhotoFriend: Object, Codable{

    @objc dynamic var id: Int // идентификатор фотографии
    @objc dynamic var countLikes: Int
    @objc dynamic var userLikes: Bool
    @objc dynamic var photo_url: String
    
    
    init(_ json: JSON) {
        
        self.id = json["id"].intValue
        self.countLikes = json["likes"]["count"].intValue
        self.userLikes = json["likes"]["user_likes"].intValue == 1 ? true : false
        
        let arrayPhotos = json["sizes"].arrayValue
        
        var findPhotoUrl = ""
        
        arrayPhotos.forEach {
            if $0["type"].stringValue == "x" {
                findPhotoUrl = $0["url"].stringValue
            }
        }
        
        self.photo_url = String(findPhotoUrl)
    }
}
