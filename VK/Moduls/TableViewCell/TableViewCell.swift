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
    @IBOutlet weak var avatarImage: ImageCellView?
    
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
    
    func configureFriend(with friend: Friend) {
        
        id = friend.id
        
        nameCell.text = "\(friend.firstName) \(friend.lastName)"
        descripCell.text = friend.city?.title
        
        let url = URL(string: friend.photo50)
        avatarImage?.photoImage.sd_setImage(with: url, completed: nil)
    }
    
    func configureGroups(with group: Group) {
        
        id = group.id
        
        nameCell.text = group.name
        descripCell.text = "\(separatedNumber(group.membersCount)) подписчиков"
        
        let url = URL(string: group.photo50)
        avatarImage?.photoImage.sd_setImage(with: url, completed: nil)
    }
}

func separatedNumber(_ number: Any) -> String {
    guard let itIsANumber = number as? NSNumber else { return "Not a number" }
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = " "
    formatter.decimalSeparator = ","
    return formatter.string(from: itIsANumber)!
}
