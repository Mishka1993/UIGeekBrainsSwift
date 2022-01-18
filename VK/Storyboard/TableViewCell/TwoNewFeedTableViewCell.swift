//
//  TwoNewFeedTableViewCell.swift
//  VK
//
//  Created by Екатерина on 19.11.2021.
//

import UIKit

class TwoNewFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var imageGroup: UIImageView!
    @IBOutlet weak var nameGroupLabel: UILabel!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    @IBOutlet weak var superImageView: UIView!
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var likeView: UIView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCount: UILabel!
    
    func recognizerView() { // Наблюдатель нажатий
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addLike)) // создание наблюдателя
        recognizer.numberOfTapsRequired = 1 // Количество нажатий для реагирования
        recognizer.numberOfTouchesRequired = 1 // Количество пальцев для реагирования
        likeView.addGestureRecognizer(recognizer) // Добавлять наблюдатель на вью
    }
    
    var indexPathRow: Int?
    
    // Функция нажатия лайка
    @objc func addLike() {
        
        guard let indexPathRowCell = indexPathRow else { return }
        let controller = NewsFeedViewController()
        if !controller.posts[indexPathRowCell].isLiked {
            controller.posts[indexPathRowCell].likes += 1 // Добавляем лайк
            likeCount.text = String(controller.posts[indexPathRowCell].likes) // Добавляем в Label
            controller.posts[indexPathRowCell].isLiked = true
            
            // Меняем лайк на заполненное сердечко с анимацией
            UIView.transition(with: likeImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.likeImage.image = UIImage(systemName: "heart.fill") // Заполненное сердечко
                                self?.likeImage.tintColor = .red  // Меняем цвет на красный
                              })
        } else {
            controller.posts[indexPathRowCell].likes -= 1 // Добавляем лайк
            likeCount.text = String(controller.posts[indexPathRowCell].likes) // Добавляем в Label
            controller.posts[indexPathRowCell].isLiked = false
            
            // Меняем обратно на пустое сердечко с анимацией
            UIView.transition(with: likeImage,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.likeImage.image = UIImage(systemName: "heart") // Пустое сердечко
                                self?.likeImage.tintColor = .systemGray2 // Меняем на цвет не активного лайка
                              })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recognizerView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
