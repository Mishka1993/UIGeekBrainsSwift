//
//  TableViewController.swift
//  VK
//
//  Created by Екатерина on 06.11.2021.
//

import UIKit
import Foundation

struct friendsModel {
    var nameFriend: String
    var photoFriend: [UIImage]
    var descripFriend: String
}

class ProfileUITableView: UIViewController {
    @IBOutlet weak var profileTableView: UITableView!
   
    
    private var userInfo = friendsModel(nameFriend: "Анджелина Джоли", photoFriend: [UIImage(named: "Анджелина Джоли")!, UIImage(named: "Анджелина Джоли")!], descripFriend: "USA")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
}
extension ProfileUITableView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableCell", for: indexPath) as? ProfileUserTableViewCell
            else { return UITableViewCell() }
            let name = userInfo.nameFriend
            let photo: UIImage
            
            if userInfo.photoFriend.count != 0 {
                photo = userInfo.photoFriend[0]
            } else {
                photo = UIImage(named: "default")!
            }
            let description = userInfo.descripFriend
            
            cell.configurate(fullName: name, imgProfile: photo, description: description)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableFriendesCell", for: indexPath) as? ProfileUserFriendsTableViewCell
            else { return UITableViewCell() }
            return cell
        }
    }
}
