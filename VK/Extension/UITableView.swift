//
//  UITableView.swift
//  VkClient
//
//  Created by Екатерина on 09.12.2021.
// тест

import UIKit
import RealmSwift

extension UITableView {
  func applyChanges<T>(changes: RealmCollectionChange<T>) {
    switch changes {
      case .initial: reloadData()
      case .update(_, let deletions, let insertions, let updates):
        let fromRow = { (row: Int) in return IndexPath(row: row, section: 0) }
        beginUpdates()
        insertRows(at: insertions.map(fromRow), with: .automatic)
        reloadRows(at: updates.map(fromRow), with: .automatic)
        deleteRows(at: deletions.map(fromRow), with: .automatic)
        endUpdates()
      case .error(let error): fatalError("\(error)")
    }
  }
}

extension UITableViewController {
    func configGroupCell(cell: inout UITableViewCell, group: RealmGroup) {
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.isOpaque = true

        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.text

        cell.imageView?.image = UIImage(named: "placeholder")
        cell.imageView?.lazyLoadingImage(link: group.photo, contentMode: .scaleAspectFit)
    }

    func configGroupCell(cell: inout UITableViewCell, group: GroupDAO) {
        cell.textLabel?.backgroundColor = .white
        cell.textLabel?.isOpaque = true

        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = group.description

        cell.imageView?.image = UIImage(named: "placeholder")
        cell.imageView?.lazyLoadingImage(link: group.photo50, contentMode: .scaleAspectFit)
    }
}

