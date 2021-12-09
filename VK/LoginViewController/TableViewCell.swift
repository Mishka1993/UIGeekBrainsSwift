//
//  TableViewCell.swift
//  VK
//
//  Created by Екатерина on 04.11.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Frindes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    extension ViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
               return 1
           }
           
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 10
           }
           
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "SomeCell", for: indexPath) as! TableViewCell
               cell.Frindes.text = "hello table"
               return cell
           }
    }
    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("нажата строка № \(indexPath.row) в секции \(indexPath.section)")
        }
    }
}
