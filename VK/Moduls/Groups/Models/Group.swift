//
//  File.swift
//  VK
//
//  Created by Екатерина on 22.12.2021.
//

import Foundation


// MARK: - Group
struct Group: Codable {
    let isMember, id: Int
    let photo100: String
    let isAdvertiser, isAdmin: Int
    let photo50, photo200: String
    let type, screenName, name: String
    let isClosed: Int
    let membersCount: Int

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
