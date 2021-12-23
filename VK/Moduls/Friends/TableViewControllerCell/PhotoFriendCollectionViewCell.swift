//
//  PhotoFriendCollectionViewCell.swift
//  VK
//
//  Created by Екатерина on 23.12.2021.
//

import UIKit
import Alamofire

class PhotoFriendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var countLike: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        image.image = nil
        countLike.text = ""
       
    }
    
    func configure(with photoFriends: PhotoFriend) {
        countLike.text = String(photoFriends.countLikes)
        let url = URL(string: photoFriends.photo_url)
        image.sd_setImage(with: url, completed: nil)

    }
}
