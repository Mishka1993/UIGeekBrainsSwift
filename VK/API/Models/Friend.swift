import Foundation
import RealmSwift

struct FriendItems: Codable {
    var items: [FriendDAO]
}

// MARK: - FriendDAO
class FriendDAO: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var trackCode: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var photo50: String = ""
    @objc dynamic var lastName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case trackCode = "track_code"
        case firstName = "first_name"
        case photo50 = "photo_50"
        case lastName = "last_name"
    }
    
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.photo50 = try values.decode(String.self, forKey: .photo50)
        self.lastName = try values.decode(String.self, forKey: .lastName)
    }
}

final class FriendsDB {
    
    init() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 3)
    }
    
    func save(_ items: [FriendDAO]) {
        let realm = try! Realm()
        deleteAll()
        try! realm.write {
            realm.add(items)
        }
        
    }
    
    func fetch() -> Results<FriendDAO> {
        let realm = try! Realm()
        
        let friends: Results<FriendDAO> = realm.objects(FriendDAO.self)
        return friends
    }
    
    func deleteAll() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func delete(_ item: FriendDAO) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(item)
        }
        
    }
}
extension FriendDAO {
    var photoUrl: URL? {
        URL(string: photo50)
    }
}
