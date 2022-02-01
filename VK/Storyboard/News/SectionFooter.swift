//
//  SectionFooter.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit

class SectionFooter: UITableViewHeaderFooterView {
    @IBOutlet var likeImageView: UIImageView!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentImageView: UIImageView!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var repostImageView: UIImageView!
    @IBOutlet var repostLabel: UILabel!
    @IBOutlet var viewImageView: UIImageView!
    @IBOutlet var viewLabel: UILabel!

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
