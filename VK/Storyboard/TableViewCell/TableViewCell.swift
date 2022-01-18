//
//  TableViewCell.swift
//  VK
//
//  Created by Екатерина on 15.11.2021.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {
    private var id: Int!
    
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var descripCell: UILabel!
    @IBOutlet weak var avatarImage: ImageCellView!
    
    var imageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }

    func clearCell() {
        nameCell.text = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    
  
}


