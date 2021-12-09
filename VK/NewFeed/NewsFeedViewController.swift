//
//  NewsFeedViewController.swift
//  VK
//
//  Created by Екатерина on 17.11.2021.
//

import UIKit

class NewsFeedViewController: UIViewController {
    @IBOutlet weak var newsFeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
        
        newsFeedTableView.register(UINib(nibName: "NewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "newsViewControllerIdentifier")
        self.newsFeedTableView.tableFooterView = UIView()
    }
}
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsViewControllerIdentifier", for: indexPath) as? NewFeedTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configurate(post: posts[indexPath.row], indexPath: indexPath.row)
        return cell
    }
}
