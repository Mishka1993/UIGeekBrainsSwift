//
//  NewsTableViewController.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit
import SDWebImage

class NewsTableViewController: UITableViewController {
    private var sections = [NewsSection]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let networkService = NetworkServices()
    private var pullControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        registerNib()
        loadData()
        
        pullControl.attributedTitle = NSAttributedString(string: "News refresh")
        pullControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = pullControl
    }
    
    func loadData() {
        var sectionDataContent = [NewsSection]()
        
        networkService.getNews { [weak self] resp in
            guard let self = self,
                  resp.newsItems.items.count > 0
            else { return }
            
            for itemNews in resp.newsItems.items {
                var authorTitle = ""
                var authorPhoto: URL?
                var dataRow = [NewsDataRow]()
                var isDataRowFill = false
                
                if let photoAttach = itemNews.attachments?[0].photo?.sizes {
                    // cell type photo
                    dataRow.append(NewsDataRow(type: .photo, photo: photoAttach.getImageByType(type: "x")?.photoUrl))
                    isDataRowFill = true
                }
                
                if !(itemNews.text?.isEmpty ?? false) {
                    // cell type text
                    dataRow.append(NewsDataRow(type: .text, text: itemNews.text))
                    isDataRowFill = true
                }
                
                if itemNews.sourceId > 0 {
                    // profile
                    if let profile = resp.profileItems.profiles.first(where: { Int32($0.id) == abs(Int32(itemNews.sourceId)) }) {
                        authorTitle = "\(profile.lastName) \(profile.firstName)"
                        authorPhoto = profile.photoUrl
                    }
                } else {
                    // group
                    if let group = resp.groupItems.groups.first(where: { $0.id == abs(Int32(itemNews.sourceId)) }) {
                        authorTitle = group.name
                        authorPhoto = group.photoUrl
                    }
                }
                
                // default...
                if !isDataRowFill {
                    dataRow.append(NewsDataRow(type: .text, text: "Контент события не определен (.."))
                }
                
                sectionDataContent.append(NewsSection(
                    postId: itemNews.postId,
                    date: itemNews.postDate,
                    author: authorTitle,
                    authorPhoto: authorPhoto,
                    comments: itemNews.comments?.count ?? 0,
                    likes: itemNews.likes?.count ?? 0,
                    views: itemNews.views?.count ?? 0,
                    reposts: itemNews.reposts?.count ?? 0,
                    data: dataRow
                ))
            }
            self.sections = sectionDataContent
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
    
    @objc func refresh(_: AnyObject) {
        loadData()
        refreshControl?.endRefreshing()
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
            if let url = sectionData.photo{
                cell.postPhotoImageView?.sd_setImage(with: url, completed: nil)
            }
            
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
        
        // clip image
        view.authorImageView.clip(cornerRadius: 10, borderColor: UIColor.lightGray.cgColor)
        
        if let url = sectionData.authorPhoto{
            view.authorImageView?.sd_setImage(with: url, completed: nil)
        }
        
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
