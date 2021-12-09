//
//  GroupTableViewCell.swift
//  VK
//
//  Created by Екатерина on 12.11.2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    @IBOutlet weak var nameGroupTableViewCell: UILabel!
    @IBOutlet weak var imageGroupImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
