//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Екатерина on 21.12.2021.
//

import UIKit
import SDWebImage

final class FriendsTableViewController: UITableViewController {
    
    var friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    
    private var networkServices = NetworkServices()
    private var friends: [Friend] = []
    private var sortedFriends = [Character: [Friend]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: friendsViewControllerIdentifier)
        
        networkServices.getFriends { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            
            self.tableView.reloadData()
        }
        self.tableView.tableFooterView = UIView()
        
    }
    func arrayLetter() -> [String] {
        var resultArray = [String]()
        
        for item in friends {
            let firstLetter = String(item.firstName.prefix(1))
            if !resultArray.contains(firstLetter) {
                resultArray.append(firstLetter)
            }
        }
        
        let sortedResultArray = resultArray.sorted() {$0 < $1}
        
        return sortedResultArray
    }
    
    func arrayByLetter(letter: String) -> [Friend] {
        var resultArray = [Friend]()
        
        for item in friends {
            let firstLetter = String(item.firstName.prefix(1))
            if firstLetter == letter {
                resultArray.append(item)
            }
        }
        
        return resultArray
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return arrayLetter().count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrayLetter()[section].uppercased()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayByLetter(letter: arrayLetter()[section]).count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrayLetter()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        
        let friend = arrayByLetter(letter: arrayLetter()[indexPath.section])
        cell.configureFriend(with: friend[indexPath.row])
        
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
            let fristLetter = arrayByLetter(letter: arrayLetter()[indexPath.section])
            destination.navigationItem.title = "Фото \(fristLetter[indexPath.row].firstName)"
            destination.userId = fristLetter[indexPath.row].id
        }
    }
}

