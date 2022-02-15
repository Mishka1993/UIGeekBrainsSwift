//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Екатерина on 21.12.2021.
//

import UIKit
import SDWebImage
import RealmSwift

final class FriendsTableViewController: UITableViewController {
    
    var friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    
    private var networkServices = NetworkServices()
    private var friends: Results<FriendDAO>?
    private var friendsDB = FriendsDB()
    private var token: NotificationToken?
    private var photoService: PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: friendsViewControllerIdentifier)
        
        networkServices.getFriends { [weak self] friends in
            guard let self = self else { return }
            self.friendsDB.save(friends)
            self.friends = self.friendsDB.fetch()
            print(self.friends! )
            self.token = self.friends?.observe(on: .main, { [weak self] changes in
                
                guard let self = self else { return }
                
                switch changes {
                case .initial:
                    self.tableView.reloadData()
                    
                case .update(_, let deletions, let insertions, let modifications):
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                    self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    self.tableView.endUpdates()
                    
                case .error(let error):
                    print("\(error)")
                }
                
            })
        }
        self.tableView.tableFooterView = UIView()
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            guard let friends = friends else { return 0 }
            return friends.count
        }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        
        guard let friend = friends?[indexPath.row] else {return cell}
        cell.nameCell.text = "\(friend.firstName ) \(friend.lastName )"
        cell.descripCell.text = ""
        
        cell.imageURL = URL(string: friend.photo50 )
        cell.avatarImage?.photoImage.sd_setImage(with: cell.imageURL, completed: nil)
        cell.avatarImage.photoImage.image = photoService?.photo(atIndexpath: indexPath, byUrl: friend.photo50) ?? nil
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let key = view as? UITableViewHeaderFooterView {
            key.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            key.textLabel?.textColor = .tintColor
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPhotos", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PhotoFriendsCollectionViewController {
            let indexPath = sender as! IndexPath
            destination.navigationItem.title = "Фото \(String(describing: friends![indexPath.row].firstName))"
            destination.userId = friends?[indexPath.row].id
        }
    }
}

