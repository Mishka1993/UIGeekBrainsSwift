//
//  RecomendationViewController.swift
//  VK
//
//  Created by Екатерина on 12.11.2021.
//

import UIKit

class RecomendationViewController: UIViewController {
    @IBOutlet weak var recomendationTableView: UITableView!
    var recomendationGroups = [groupModel(nameGroup: "Планеты", imageGroup: "Планеты"), groupModel(nameGroup: "Музыка", imageGroup: "Музыка")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recomendationTableView.delegate = self
        recomendationTableView.dataSource = self
    }
}
extension RecomendationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recomendationGroups.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = recomendationTableView.dequeueReusableCell(withIdentifier: "groupsTableViewCell") as? RecomdetaionTableViewCell else {
            return UITableViewCell()
        }
        let com = recomendationGroups[indexPath.row]
        cell.nameRecomendation.text = com.nameGroup
        cell.imageRecomendation.image = UIImage(named: com.imageGroup)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
