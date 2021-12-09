//
//  SearchGroupsViewController.swift
//  VK
//
//  Created by Екатерина on 15.11.2021.
//

import UIKit

class SearchGroupsViewController: UIViewController {
    @IBOutlet weak var searchViewBar: UISearchBar!
    @IBOutlet weak var groupsSearchView: UITableView!
    var searchFlag = false
    var filtredGroups = [groupModel]()
    var groups = [groupModel(nameGroup: "Авто", imageGroup: UIImage(named: "Авто"), description: "Все про авто"),
                  groupModel(nameGroup: "Музыка", imageGroup: UIImage(named: "Музыка"), description: "Все про музыку"),
                  groupModel(nameGroup: "Планеты", imageGroup: UIImage(named: "Планеты"), description: "Все про планеты"),
                  groupModel(nameGroup: "Спорт", imageGroup: UIImage(named: "Спорт"), description: "Все про Спорт"),
                  groupModel(nameGroup: "Стройка", imageGroup: UIImage(named: "Стройка"), description: "Стройка")]
    
    func arrayGroups() -> [groupModel] {
        if searchFlag {
            return filtredGroups
        } else {
            return groups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsSearchView.delegate = self
        groupsSearchView.dataSource = self
        searchViewBar.delegate = self
        
        groupsSearchView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "searchViewControllerIdentifier")
        
        self.groupsSearchView.tableFooterView = UIView()
    }
}
extension SearchGroupsViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayGroups().count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchViewControllerIdentifier", for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        let group = arrayGroups()[indexPath.row]
        cell.configurate(fullName: group.nameGroup, imgProfile: group.imageGroup, description: group.descrip)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroup", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchFlag = false
        } else {
            searchFlag = true
            filtredGroups = groups.filter({ item in
                item.nameGroup.lowercased().contains(searchText.lowercased())
            })
        }
        groupsSearchView.reloadData()
    }
}
