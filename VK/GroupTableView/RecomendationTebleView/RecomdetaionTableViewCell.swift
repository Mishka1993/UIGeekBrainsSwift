//
//  RecomdetaionTableViewCell.swift
//  VK
//
//  Created by Екатерина on 12.11.2021.
//

import UIKit

class RecomdetaionTableViewCell: UITableViewCell {
    @IBOutlet weak var nameRecomendation: UILabel!
    @IBOutlet weak var imageRecomendation: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
