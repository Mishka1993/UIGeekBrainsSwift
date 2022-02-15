//
//  SectionHeader.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var datePostLabel: UILabel!

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
