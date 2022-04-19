//
//  VkAdapter.swift
//  VK
//
//  Created by Михаил Киржнер on 28.03.2022.
//

import Foundation
import RealmSwift

enum RealmEntity {
    case user, photo, group
}

final class APIAdapter: NetworkServiceProtocol {
    func getFriends(completion: @escaping ([FriendDAO]) -> Void) {
        <#code#>
    }
    
    func getPhotos(ownerId: Int, completion: @escaping ([PhotoFriend]) -> Void) {
        <#code#>
    }
    
    func getGroups(completion: @escaping ([GroupDAO]) -> Void) {
        <#code#>
    }
    
    func searchGroups(query: String, completion: @escaping ([GroupDAO]) -> Void) {
        <#code#>
    }
    
    func joinToGroup(groupId: Int, completion: @escaping (Int) -> Void) {
        <#code#>
    }
    
    func leaveGroup(groupId: Int, completion: @escaping (Int) -> Void) {
        <#code#>
    }
    
    func getNews(startFrom: String?, completion: @escaping (NewsResponseDTO) -> Void) {
        <#code#>
    }
    
    private var realmNotificationTokens: [RealmEntity: NotificationToken] = [:]
    
    func getFriends(completion: @escaping ([FriendDAO]?) -> Void) {
        if let realm = try? Realm(configuration: RealmService.deleteIfMigration) {
            let users = realm.objects(FriendDAO.self)
            realmNotificationTokens[.user]?.invalidate()
            let token = users.observe { [weak self] changes in
                switch changes {
                case .initial:
                    break
                case .update(let users, _, _, _):
                    completion(users.map { $0 })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
            realmNotificationTokens[.user] = token
            AppSettings
                .instance
                .apiService
                .getFriendsByPromise()
        }
    }
}
