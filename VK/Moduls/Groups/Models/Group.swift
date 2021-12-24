//
//  File.swift
//  VK
//
//  Created by Екатерина on 22.12.2021.
//

import Foundation
import RealmSwift

// MARK: - Group
class Group: Object, Codable {
    @objc dynamic var isMember, id: Int
    @objc dynamic var photo100: String
    @objc dynamic var isAdvertiser, isAdmin: Int
    @objc dynamic var photo50, photo200: String
    @objc dynamic var type, screenName, name: String
    @objc dynamic var isClosed: Int
    @objc dynamic var membersCount: Int

    enum CodingKeys: String, CodingKey {
        case isMember = "is_member"
        case id, type, name
        case photo100 = "photo_100"
        case isAdvertiser = "is_advertiser"
        case isAdmin = "is_admin"
        case photo50 = "photo_50"
        case photo200 = "photo_200"
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case membersCount = "members_count"
    }
}
