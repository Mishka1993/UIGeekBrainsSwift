//
//  NewFeedTableViewCell.swift
//  VK
//
//  Created by Екатерина on 17.11.2021.
//

import UIKit

var posts = [
    Post(group: groupModel(nameGroup: "Авто", imageGroup: UIImage(named: "Авто")),
         descriptionPost: "Tesla выпустила рестайлинг model 3",
         imagePost: UIImage(named: "model3"),
         isLiked: false,
         likes: 0),
    Post(group: groupModel(nameGroup: "Планеты", imageGroup: UIImage(named: "Планеты")),
         descriptionPost: "Плутон сново признали планетой ",
         imagePost: UIImage(named: "плутон"),
         isLiked: false,
         likes: 0),
    Post(group: groupModel(nameGroup: "Спорт", imageGroup: UIImage(named: "Спорт")),
         descriptionPost: "Сборная россии по футболу прошла отборочный на евро",
         imagePost: UIImage(named: "футбол"),
         isLiked: false,
         likes: 0),
    Post(group: groupModel(nameGroup: "Спорт", imageGroup: UIImage(named: "Спорт")),
         descriptionPost: "Сборная россии по футболу прошла отборочный на евро",
         imagePost: nil,
         isLiked: false,
         likes: 0)
]

class NewFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGroupLabel: UILabel!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    @IBOutlet weak var superImageView: UIView!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    
    func recognizerView() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addLike))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        likeView.addGestureRecognizer(recognizer)
    }
    
    var indexPathRow: Int?
    
    @objc func addLike() {
        
        guard let indexPathRowCell = indexPathRow else { return }
        if !posts[indexPathRowCell].isLiked {
            posts[indexPathRowCell].likes += 1
            likeCount.text = String(posts[indexPathRowCell].likes)
            posts[indexPathRowCell].isLiked = true
            
            UIView.transition(with: likeImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.likeImage.image = UIImage(systemName: "heart.fill")
                                self?.likeImage.tintColor = .red
                              })
        } else {
            posts[indexPathRowCell].likes -= 1
            likeCount.text = String(posts[indexPathRowCell].likes)
            posts[indexPathRowCell].isLiked = false
            
            UIView.transition(with: likeImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.likeImage.image = UIImage(systemName: "heart")
                                self?.likeImage.tintColor = .systemGray2
                              })
        }
    }
    func setup() {
        
        guard let indexPathRowCell = indexPathRow else { return }
        
        if posts[indexPathRowCell].isLiked {
            likeImage.image = UIImage(systemName: "heart.fill")
            likeImage.tintColor = .red
        }
    }
    func configurate(post: Post?, indexPath: Int) {
        guard let post = post else { return }
        
        imageGroup.image = post.group.imageGroup
        nameGroupLabel.text = post.group.nameGroup
        descriptionPostLabel.text = post.descriptionPost
        oneImageView.image = post.imagePost
        likeCount.text = String(post.likes)
        
        indexPathRow = indexPath
        
        setup()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        recognizerView()
    }
}
