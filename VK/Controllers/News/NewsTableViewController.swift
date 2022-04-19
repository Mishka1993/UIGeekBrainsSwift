//
//  NewsTableViewController.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import UIKit
import SDWebImage

class NewsTableViewController: UITableViewController {
    private var sections = [NewsSection]()
    private let networkService = NetworkServices()
    private var pullControl = UIRefreshControl()
    private var newsNextStartQueryParam: String?
    private var isLoading = false
    private let textCellFont = UIFont(name: "HelveticaNeue", size: 16.0)!
    private let defaultCellHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        registerNib()
        loadData()
        
        pullControl.attributedTitle = NSAttributedString(string: "News refresh")
        pullControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = pullControl
    }
    
    func loadData() {
        networkService.getNews { [weak self] resp in
            guard let self = self,
                  resp.newsItems.items.count > 0
            else { return }
            
            self.sections = self.prepareSectionData(newsResponse: resp)
            self.newsNextStartQueryParam = resp.nextFrom
            self.tableView.reloadData()
        }
    }
    
    private func prepareSectionData(newsResponse: NewsResponseDTO) -> [NewsSection] {
        var sectionDataContent = [NewsSection]()
        for itemNews in newsResponse.newsItems.items {
            var authorTitle = ""
            var authorPhoto: URL?
            var dataRow = [NewsDataRow]()
            var isDataRowFill = false
            
            if let photoAttach = itemNews.attachments?[0].photo?.sizes {
                // cell type photo
                dataRow.append(NewsDataRow(type: .photo, photo: photoAttach.getImageByType(type: "y")))
                isDataRowFill = true
            }
            
            if !(itemNews.text?.isEmpty ?? false) {
                // cell type text
                dataRow.append(NewsDataRow(type: .text, text: itemNews.text))
                isDataRowFill = true
            }
            
            if itemNews.sourceId > 0 {
                // profile
                if let profile = newsResponse.profileItems.profiles.first(where: { $0.id == abs(Int32(itemNews.sourceId)) }) {
                    authorTitle = "\(profile.lastName) \(profile.firstName)"
                    authorPhoto = profile.photoUrl
                }
            } else {
                // group
                if let group = newsResponse.groupItems.groups.first(where: { $0.id == abs(Int32(itemNews.sourceId)) }) {
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
        
        return sectionDataContent
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
            let textHeight = sectionData.text?.heightWithConstrainedWidth(width: tableView.frame.width, font: textCellFont) ?? 0
            cell.cellInit(text: sectionData.text, isShowExpandBtn: textHeight > defaultCellHeight)
            cell.delegate = self
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoViewCell", for: indexPath) as! PhotoViewCell
            if let url = sectionData.photo?.photoUrl{
                cell.postPhotoImageView?.sd_setImage(with: url, completed: nil)
            }
            
            return cell
            
            
        }
    }
    
    // MARK: Calc cell height
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableWidth = tableView.bounds.width
        let section = sections[indexPath.section]
        let sectionData = section.data[indexPath.row]
        
        switch sectionData.type {
        case .photo where sectionData.photo != nil:
            return sectionData.photo!.aspectRatio * tableWidth
        case .text:
            let cell = tableView.cellForRow(at: indexPath) as? TextViewCell
            return (cell?.isExpanded ?? false) ? UITableView.automaticDimension : defaultCellHeight
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_: UITableView, estimatedHeightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? SectionHeader
        else { return nil }
        
        let sectionData = sections[section]
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

// MARK: Lazy loading

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            !isLoading,
            let maxSection = indexPaths.map({ $0.section }).max(),
            maxSection > sections.count - 3
        else { return }
        isLoading = true
        
        networkService.getNews(startFrom: newsNextStartQueryParam) { [weak self] resp in
            guard let self = self,
                  resp.newsItems.items.count > 0
            else { return }
            
            let newSectionData = self.prepareSectionData(newsResponse: resp)
            if !resp.nextFrom.isEmpty {
                self.newsNextStartQueryParam = resp.nextFrom
            }
            
            let indexSet = IndexSet(integersIn: self.sections.count ..< newSectionData.count + self.sections.count)
            newSectionData.forEach { item in
                self.sections.append(item)
            }
            
            tableView.insertSections(indexSet, with: .automatic)
            self.isLoading = false
        }
    }
}

extension NewsTableViewController: ExpandCellDelegate {
    func moreTapped(cell _: TextViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
