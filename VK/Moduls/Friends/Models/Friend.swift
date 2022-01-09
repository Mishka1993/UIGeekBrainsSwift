import Foundation
import RealmSwift
import SwiftyJSON

// MARK: - Friend
class Friend: Object {
    @objc dynamic var id = 0
    @objc dynamic var photo100 = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo50 = ""
    @objc dynamic var trackCode = ""
    @objc dynamic var firstName = ""
    @objc dynamic var city = ""
    
    override static func primaryKey() -> String? {
            return "id"
        }
    
    convenience init(json: JSON){
        self.init()
        
        self.id = json["id"].intValue
        self.photo100 = json["photo_100"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo50 = json["photo_50"].stringValue
        self.trackCode = json["track_code"].stringValue
        self.firstName = json["firstName"].stringValue
        self.city = json["city"]["title"].stringValue
    }
//    enum CodingKeys: String, CodingKey {
//        case domain, id
//        case photo100 = "photo_100"
//        case lastName = "last_name"
//        case photo50 = "photo_50"
//        case trackCode = "track_code"
//        case firstName = "first_name"
//    }
}
