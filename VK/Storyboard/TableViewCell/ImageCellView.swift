//
//  ImageCellView.swift
//  VK
//
//  Created by Екатерина on 22.12.2021.
//

import UIKit

class ImageCellView: UIView {
    @IBInspectable var shadowColor: UIColor = .lightGray
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: -3)
    @IBInspectable var shadowOpacity: Float = 0.8
    @IBInspectable var shadowRadius: CGFloat = 3
    let photoImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImage.layer.cornerRadius = self.frame.height / 2
        photoImage.layer.masksToBounds = true
        self.backgroundColor = .clear
        photoImage.removeFromSuperview()
        addSubview(photoImage)
        photoImage.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap))
        recognizer.numberOfTapsRequired = 1    // количество нажатий для распознавания
        return recognizer
    }()
    
    @objc func onTap() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = transform.self
        scaleAnimation.toValue = 0.9
        scaleAnimation.duration = 0.1
        scaleAnimation.autoreverses = true
        layer.add(scaleAnimation, forKey: nil)
    }
}
