//
//  PhotoFriendViewController.swift
//  VK
//
//  Created by Екатерина on 11.11.2021.
//

import UIKit

class PhotoFriendViewController: UIViewController {
    @IBOutlet weak var galleryView: AnimatePhotoFriends!
    var friend: friendsModel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryView.setImages(images: friend.photoFriend)
    }
    
}
