//
//  FriendsViewController.swift
//  VK
//
//  Created by Екатерина on 11.11.2021.
//

import UIKit

class FriendsViewController: UIViewController {
    @IBOutlet weak var friendsTableView: UITableView!
    var friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    var friends = [friendsModel(nameFriend: "Анджелина Джоли", photoFriend: [UIImage(named: "Анджелина Джоли")!, UIImage(named: "Анджелина Джоли")!], descripFriend: "USA"),
                          friendsModel(nameFriend: "Арнольд Шварценеггер", photoFriend: [UIImage(named: "Арнольд Шварценеггер")!,UIImage(named: "Арнольд Шварценеггер")!], descripFriend: "USA"),
                          friendsModel(nameFriend: "Брэт Питт", photoFriend: [UIImage(named: "Брэт Питт")!,UIImage(named: "Брэт Питт")!],descripFriend: "USA"),
                          friendsModel(nameFriend: "Брюс Ли", photoFriend: [UIImage(named: "Брюс Ли")!, UIImage(named: "Брюс Ли")!],descripFriend: "China"),
                          friendsModel(nameFriend: "Брюс Уиллис", photoFriend: [UIImage(named: "Брюс Уиллис")!, UIImage(named: "Брюс Уиллис")!],descripFriend: "USA"),
                          friendsModel(nameFriend: "Дольф Лундгрен", photoFriend: [UIImage(named: "Дольф Лундгрен")!, UIImage(named: "Дольф Лундгрен")!],descripFriend: "USA"),
                          friendsModel(nameFriend: "Квентин Тарантино", photoFriend: [UIImage(named: "Квентин Тарантино")!, UIImage(named: "Квентин Тарантино")!],descripFriend: "USA"),
                          friendsModel(nameFriend: "Стэнли Туччи", photoFriend: [UIImage(named: "Стэнли Туччи")!, UIImage(named: "Стэнли Туччи")!], descripFriend: "USA"),
                          friendsModel(nameFriend: "Том Круз", photoFriend: [UIImage(named: "Том Круз")!, UIImage(named: "Том Круз")!], descripFriend: "USA"),
                          friendsModel(nameFriend: "Уилл Смит", photoFriend: [UIImage(named: "Уилл Смит")!, UIImage(named: "Уилл Смит")!], descripFriend: "USA"),
                          friendsModel(nameFriend: "Хью Джекман", photoFriend: [UIImage(named: "Хью Джекман")!, UIImage(named: "Хью Джекман")!], descripFriend: "USA")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self

        self.friendsTableView.tableFooterView = UIView()
        friendsTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: friendsViewControllerIdentifier)
    }
    
    func arrayLetter() -> [String] {
        var resultArray = [String]()
        
        for item in friends {
            let firstLetter = String(item.nameFriend.prefix(1))
            if !resultArray.contains(firstLetter) {
                resultArray.append(firstLetter)
            }
        }
        
        let sortedResultArray = resultArray.sorted() {$0 < $1}
        
        return sortedResultArray
    }
    
    func arrayByLetter(letter: String) -> [friendsModel] {
        var resultArray = [friendsModel]()
        
        for item in friends {
            let firstLetter = String(item.nameFriend.prefix(1))
            if firstLetter == letter {
                resultArray.append(item)
            }
        }
        
        return resultArray
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayLetter().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayLetter()[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayByLetter(letter: arrayLetter()[section]).count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrayLetter()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        
        let friend = arrayByLetter(letter: arrayLetter()[indexPath.section])
        
        let name = friend[indexPath.row].nameFriend
        let photo: UIImage
        
        if friend[indexPath.row].photoFriend.count != 0 {
            photo = friend[indexPath.row].photoFriend[0]
        } else {
            photo = UIImage(named: "default")!
        }
        let description = friend[indexPath.row].descripFriend
        
        cell.configurate(fullName: name, imgProfile: photo, description: description)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let key = view as? UITableViewHeaderFooterView {
            key.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            key.textLabel?.textColor = .tintColor
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPhotos", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoFriendViewController {
            let indexPath = sender as! IndexPath
            destination.friend = arrayByLetter(letter: arrayLetter()[indexPath.section])[indexPath.row]
        }
    }
}
