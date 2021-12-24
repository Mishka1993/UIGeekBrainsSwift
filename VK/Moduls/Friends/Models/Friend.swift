import Foundation
import RealmSwift

// MARK: - Friend
class Friend: Object, Codable {
    @objc dynamic var domain: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var photo100: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var trackCode: String? = ""
    @objc dynamic var firstName: String = ""

    enum CodingKeys: String, CodingKey {
        case domain, id
        case photo100 = "photo_100"
        case lastName = "last_name"
        case photo50 = "photo_50"
        case trackCode = "track_code"
        case firstName = "first_name"
    }
}
