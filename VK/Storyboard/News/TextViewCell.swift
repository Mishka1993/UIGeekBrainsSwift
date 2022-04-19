//
//  TextViewCell.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit

protocol ExpandCellDelegate {
    func moreTapped(cell: TextViewCell)
}

class TextViewCell: UITableViewCell {
    var isExpanded: Bool = false
    var delegate: ExpandCellDelegate?
    
    @IBOutlet var postTextLabel: UILabel!
    @IBOutlet weak var buttonMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func expandBtn(_ sender: Any) {
        if sender is UIButton {
            isExpanded = !isExpanded
            buttonMore.setTitle(getBtnName(), for: .normal)
        }
        delegate?.moreTapped(cell: self)
    }
    public func cellInit(text: String?, isShowExpandBtn: Bool) {
        postTextLabel.text = text
        if isShowExpandBtn {
            isExpanded = false
            buttonMore.setTitle(getBtnName(), for: .normal)
            buttonMore.isHidden = false
        } else {
            buttonMore.isHidden = true
        }
    }

    private func getBtnName() -> String {
        isExpanded ? "Show less..." : "Show more..."
    }
}
