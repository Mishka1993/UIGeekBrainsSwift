//
//  FriendsTableViewCell.swift
//  VK
//
//  Created by Екатерина on 11.11.2021.
//

import UIKit


class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameFriendsLable: UILabel!
    @IBOutlet weak var photoFriendsImageView: UIImageView!
    @IBOutlet weak var imageSuperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoFriendsImageView.layer.cornerRadius = photoFriendsImageView.frame.width / 2
        photoFriendsImageView.layer.shadowColor = UIColor.darkGray.cgColor
        photoFriendsImageView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        photoFriendsImageView.layer.shadowRadius = 25.0
        photoFriendsImageView.layer.shadowOpacity = 0.9

        imageSuperView.layer.cornerRadius = imageSuperView.frame.width / 2
        imageSuperView.backgroundColor = .clear
        imageSuperView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
