//
//  GroupsViewController.swift
//  VK
//
//  Created by Екатерина on 07.11.2021.
//

import UIKit

class GroupsViewController: UIViewController {
    @IBOutlet weak var groupsView: UITableView!
    @IBOutlet weak var emtyGroupText: UILabel!
    var groups = [groupModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsView.dataSource = self
        groupsView.delegate = self
        
        groupsView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "groupsViewControllerIdentifier")
        self.groupsView.tableFooterView = UIView()
    }
    @IBAction func addGroups(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let searchGroup = segue.source as? SearchGroupsViewController
            if let indexPath = searchGroup?.groupsSearchView.indexPathForSelectedRow {
                guard let group = searchGroup?.groups[indexPath.row]
                else { return }
                for item in groups {
                    if item.nameGroup == group.nameGroup && item.imageGroup == group.imageGroup { return }
                }
                groups.append(group)
                emtyGroupText.isHidden = true
                groupsView.reloadData()
            }
        }
    }
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupsViewControllerIdentifier", for: indexPath) as? TableViewCell
        else { return UITableViewCell() }
        let group = groups[indexPath.row]
        cell.configurate(fullName: group.nameGroup, imgProfile: group.imageGroup, description: group.descrip)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
            return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if groups.count > 0 { emtyGroupText.isHidden = true }
            else { emtyGroupText.isHidden = false }
        }
    }
}

