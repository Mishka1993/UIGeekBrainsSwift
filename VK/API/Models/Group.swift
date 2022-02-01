//
//  File.swift
//  VK
//
//  Created by Екатерина on 22.12.2021.
//

import Foundation
import RealmSwift

// MARK: - Group
@objcMembers
class GroupDAO: Object, Codable {
    dynamic var isMember, id: Int
    dynamic var photo100: String
    dynamic var isAdvertiser, isAdmin: Int
    dynamic var photo50, photo200: String
    dynamic var type, screenName, name: String
    dynamic var isClosed: Int
    dynamic var membersCount: Int
    
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
final class GroupsDB {
    
    init() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 3)
    }
    
    func save(_ items: [GroupDAO]) {
        let realm = try! Realm()
        
        deleteAll()
        
        try! realm.write {
            realm.add(items)
        }
        
    }
    
    func fetch() -> Results<GroupDAO> {
        let realm = try! Realm()
        
        let group: Results<GroupDAO> = realm.objects(GroupDAO.self)
        return group
    }
    
    func deleteAll() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func delete(_ item: GroupDAO) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(item)
        }
        
    }
}
