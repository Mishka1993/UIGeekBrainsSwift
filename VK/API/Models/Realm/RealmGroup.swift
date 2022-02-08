//
//  RealmGroup.swift
//  VK
//
//  Created by Михаил Киржнер on 08.02.2022.
//

import Foundation
import RealmSwift

class RealmGroup: Object {
    @Persisted var id: String = ""
    @Persisted var groupId: Int
    @Persisted var name: String
    @Persisted var screenName: String
    @Persisted var photo: String
    @Persisted var text: String

    override class func primaryKey() -> String? {
        "id"
    }

    override class func indexedProperties() -> [String] {
        ["name"]
    }
}

extension RealmGroup {
    convenience init(group: GroupDAO) {
        self.init()
        id = UUID().uuidString
        groupId = group.id
        name = group.name
        screenName = group.screenName
        photo = group.photo50
        text = group.description
    }
}

extension RealmGroup {
    var photoUrl: URL? {
        URL(string: photo)
    }
}
