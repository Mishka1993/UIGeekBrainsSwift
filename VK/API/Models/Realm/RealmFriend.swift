//
//  RealmFriend.swift
//  VK
//
//  Created by Михаил Киржнер on 10.02.2022.
//

import Foundation
import RealmSwift

class RealmFriend: Object {
    @Persisted var id: String = ""
    @Persisted var userId: Int
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var photo: String

    override class func primaryKey() -> String? {
        "id"
    }

    override class func indexedProperties() -> [String] {
        ["userId"]
    }
}

extension RealmFriend {
    convenience init(friend: FriendDAO) {
        self.init()
        id = UUID().uuidString
        userId = friend.id
        firstName = friend.firstName
        lastName = friend.lastName
        photo = friend.photo50
    }
}

extension RealmFriend {
    var photoUrl: URL? {
        URL(string: photo)
    }
}
