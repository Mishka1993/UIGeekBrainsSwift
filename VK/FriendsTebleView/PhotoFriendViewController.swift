//
//  PhotoFriendViewController.swift
//  VK
//
//  Created by Екатерина on 11.11.2021.
//

import UIKit
import SDWebImage

class PhotoFriendViewController: UIViewController {
    @IBOutlet weak var galleryView: AnimatePhotoFriends!
    var friend: Friend!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: friend.photo50)
       // galleryView.photoImage.sd_setImage(with: url, completed: nil)
        //galleryView.setImages(images: friend.photo50)
    }
    
}
