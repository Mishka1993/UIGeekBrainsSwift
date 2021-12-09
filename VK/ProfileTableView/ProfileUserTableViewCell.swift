//
//  ProfileUserTableViewCell.swift
//  VK
//
//  Created by Екатерина on 07.12.2021.
//

import UIKit

class ProfileUserTableViewCell: UITableViewCell {
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var nameCell: UILabel!
    @IBOutlet weak var descripCell: UILabel!
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var opacity: CGFloat = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customShadow()
        recognizerImageView()
        clearCell()
    }

    func recognizerImageView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(animateImageProfile))
        recognizer.numberOfTouchesRequired = 1
        recognizer.numberOfTapsRequired = 1
        customView.addGestureRecognizer(recognizer)
    }
    
   
    @objc func animateImageProfile() {
        var bounds = self.imageCell.bounds
        bounds.size.width = 44
        bounds.size.height = 44
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       animations: { [weak self] in
                        self?.imageCell.layer.bounds = bounds
                        self?.imageCell.layer.cornerRadius = 22
                       },
                       completion: { _ in
                        
                        UIView.animate(withDuration: 3,
                                       delay: 0,
                                       usingSpringWithDamping: 0.1,
                                       initialSpringVelocity: 0,
                                       options: [],
                                       animations: { [weak self] in
                                        self?.imageCell.layer.bounds = CGRect(x: 0, y: 0, width: 48, height: 48)
                                        self?.imageCell.layer.cornerRadius  = 24
                                       } )
                        
                       })
    }
    
    func customShadow() {
        customView.layer.shadowOffset = shadowOffset
        customView.layer.shadowRadius = shadowRadius
        customView.layer.shadowOpacity = Float(opacity)
        imageCell.layer.cornerRadius = customView.frame.width / 2
        customView.backgroundColor = .clear
        imageCell.clipsToBounds = true
    }
    
    func clearCell() {
        imageView?.image = nil
        nameCell.text = nil
    }
    
    override func prepareForReuse() {
        clearCell()
    }
    
    func configurate(fullName: String?, imgProfile: UIImage?, description: String?) {
        if let profileName = fullName {
            nameCell.text = profileName
        }
         
        descripCell.text = description
        
        imageCell.image = imgProfile ?? UIImage(named: "default")
        
    }
}
