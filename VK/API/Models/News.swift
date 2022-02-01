//
//  News.swift
//  VK
//
//  Created by Михаил Киржнер on 01.02.2022.
//

import Foundation

struct NewsPost {
    var postId: Int
    var date: String
    var author: String
    var text: String
    var photo: String
    var comments: Int
    var likes: Int
    var views: Int
    var repost: Int
}

let demoNews = [
    NewsPost(
        postId: 1,
        date: "01.12.2021",
        author: "Иванов Иван",
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        photo: "news-1",
        comments: 20,
        likes: 10,
        views: 500,
        repost: 3
    ),
    NewsPost(
        postId: 2,
        date: "05.01.2022",
        author: "Петров Петр",
        text: "",
        photo: "news-2",
        comments: 12,
        likes: 33,
        views: 30,
        repost: 10
    ),
    NewsPost(
        postId: 3,
        date: "30.01.2022",
        author: "Сидоров Андрей",
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        photo: "",
        comments: 232,
        likes: 211,
        views: 44232,
        repost: 4435
    ),
]

enum CellType {
    case photo
    case text
}

struct NewsDataRow {
    var type: CellType
    var photo: String?
    var text: String?
}

struct NewsSection {
    var postId: Int
    var date: String
    var author: String
    var comments: Int
    var likes: Int
    var views: Int
    var reposts: Int
    var data: [NewsDataRow]
}

extension NewsSection {
    var authorPhoto: String {
        return "author-\(postId)"
    }
}
