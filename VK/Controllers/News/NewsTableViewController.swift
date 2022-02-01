//
//  NewsTableViewController.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit

class NewsTableViewController: UITableViewController {
    private var sections = [NewsSection]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        registerNib()
        loadData()
    }

    func loadData() {
        for item in demoNews {
            var dataRow = [NewsDataRow]()
            if !item.text.isEmpty {
                dataRow.append(NewsDataRow(type: .text, text: item.text))
            }
            if !item.photo.isEmpty {
                dataRow.append(NewsDataRow(type: .photo, photo: item.photo))
            }

            sections.append(NewsSection(
                postId: item.postId,
                date: item.date,
                author: item.author,
                comments: item.comments,
                likes: item.likes,
                views: item.views,
                reposts: item.repost,
                data: dataRow
            )
            )
        }
    }

    private func registerNib() {
        tableView.register(
            SectionHeader.nib,
            forHeaderFooterViewReuseIdentifier: "Header"
        )

        tableView.register(
            SectionFooter.nib,
            forHeaderFooterViewReuseIdentifier: "Footer"
        )

        let nibText = UINib(nibName: "TextViewCell", bundle: nil)
        tableView.register(nibText, forCellReuseIdentifier: "TextViewCell")

        let nibPhoto = UINib(nibName: "PhotoViewCell", bundle: nil)
        tableView.register(nibPhoto, forCellReuseIdentifier: "PhotoViewCell")
    }
}

extension NewsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let sectionData = section.data[indexPath.row]

        switch sectionData.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewCell
            cell.postTextLabel.text = sectionData.text
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
            cell.postPhotoImageView.image = UIImage(named: sectionData.photo ?? "default-news-image")
            return cell
        }
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? SectionHeader
        else { return nil }

        let sectionData = sections[section]
        view.authorImageView.image = UIImage(named: sectionData.authorPhoto)
        view.authorNameLabel.text = sectionData.author
        view.datePostLabel.text = sectionData.date

        return view
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer") as? SectionFooter
        else { return nil }

        let sectionData = sections[section]
        view.likeLabel.text = String(sectionData.likes)
        view.commentLabel.text = String(sectionData.comments)
        view.repostLabel.text = String(sectionData.reposts)
        view.viewLabel.text = String(sectionData.views)
        return view
    }

    override func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
        return 100.0
    }
}
