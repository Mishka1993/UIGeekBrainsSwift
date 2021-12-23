import Foundation

// MARK: - FriendsContainer
struct FriendsContainer: Codable {
    let response: FriendsResponse
}

// MARK: - Response
struct FriendsResponse: Codable {
    let count: Int
    let items: [Friend]
}

// MARK: - Item
struct Friend: Codable {
    let id: Int
    let isClosed: Bool?
    let trackCode: String
    let canAccessClosed: Bool?
    let firstName: String
    let photo50: String
    let city: City?
    let lastName: String
    let online: Int
    let nickname: String?
    let country: City?

    enum CodingKeys: String, CodingKey {
        case id
        case isClosed = "is_closed"
        case trackCode = "track_code"
        case canAccessClosed = "can_access_closed"
        case firstName = "first_name"
        case photo50 = "photo_50"
        case city
        case lastName = "last_name"
        case online, nickname, country
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let title: String
}
