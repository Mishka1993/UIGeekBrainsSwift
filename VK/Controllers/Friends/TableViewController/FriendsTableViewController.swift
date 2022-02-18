//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Екатерина on 21.12.2021.
//

import UIKit
import SDWebImage
import RealmSwift

struct Section {
    let letter: String
    let data: [RealmFriend]
}

class FriendsTableViewController: UITableViewController {
    @IBOutlet var FriendTableView: UITableView!
    var friendsViewControllerIdentifier = "friendsViewControllerIdentifier"
    private var friendToken: NotificationToken?
    private let realmProvider = ProviderDataService()
    private var friend: Results<RealmFriend>?

    private var sections = [Section]() {
        didSet {
            FriendTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        friend = try? RealmService
            .load(typeOf: RealmFriend.self)
    }

    override func viewDidAppear(_: Bool) {
        loadData()
    }

    public func loadData() {
        realmProvider.loadFriends()
        friendToken = friend?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.loadSection()
            case .update:
                self?.loadSection()
            case let .error(error):
                print(error)
            }
        }
    }

    private func getRowData(indexPath: IndexPath) -> RealmFriend {
        let section = sections[indexPath.section]
        return section.data[indexPath.row]
    }

    private func loadSection() {
        guard let friend = friend else { return }
        let groupedDictionary = Dictionary(grouping: friend, by: { String($0.lastName.prefix(1)) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map { Section(letter: $0, data: groupedDictionary[$0]!) }
    }
}

extension FriendsTableViewController {
    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TableViewCell
        if let resCell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as? TableViewCell {
            cell = resCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: friendsViewControllerIdentifier, for: indexPath) as! TableViewCell
        }

        let section = sections[indexPath.section]
        let sectionData = section.data[indexPath.row]

        cell.nameCell?.text = "\(sectionData.lastName) \(sectionData.firstName)"
        
        // add shadow to image container
        cell.avatarImage.photoImage.addShadow()

        // clip image
        cell.avatarImage.clip(borderColor: UIColor.orange.cgColor)
        cell.imageURL = URL(string: sectionData.photo)
        cell.avatarImage?.photoImage.sd_setImage(with: cell.imageURL, completed: nil)
        
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(
            withIdentifier: "showGallery",
            sender: indexPath
        )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let galleryController = segue.destination as? PhotoFriendsCollectionViewController
        else { return }
        let indexPath = sender as! IndexPath
        let rowData = getRowData(indexPath: indexPath)
        galleryController.userId = rowData.userId
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    override func sectionIndexTitles(for _: UITableView) -> [String]? {
        return sections.map { $0.letter }
    }

    override func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }

    override func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 25))

        label.text = sections[section].letter
        label.backgroundColor = .white
        label.isOpaque = true
        label.textColor = .black
        returnedView.addSubview(label)

        return returnedView
    }
}

extension FriendsTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRequireFailureOf _: UIGestureRecognizer) -> Bool {
        return true
    }
}
