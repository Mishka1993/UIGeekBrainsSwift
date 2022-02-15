//
//  PhotoGallery.swift
//  VK
//
//  Created by Михаил Киржнер on 02.02.2022.
//

import Foundation
import UIKit

struct PhotoGalleryItems: Codable {
    var items: [PhotoGallery]
}

struct PhotoGallery: Codable {
    var id: Double
    var albumId: Double
    var ownerId: Double
    var text: String
    var items: [ImageItem]

    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case text
        case items = "sizes"
    }
}

extension PhotoGallery {
    var description: String {
        if text.isEmpty {
            return "Фото из альбома №\(albumId)"
        }
        return text
    }
}

struct ImageItem: Codable {
    var type: String
    var url: String
    var width: Double
    var height: Double

    enum CodingKeys: String, CodingKey {
        case type
        case url
        case width
        case height
    }
}

extension ImageItem {
    var photoUrl: URL? {
        URL(string: url)
    }

    var image: UIImage? {
        guard let url = photoUrl else { return nil }
        let data = try? Data(contentsOf: url)
        return UIImage(data: data!)
    }

    var aspectRatio: CGFloat { width / height }
}

extension Array where Element == ImageItem {
    func getImageByType(type: String) -> Element? {
        guard let index = firstIndex(where: { $0.type == type }) else {
            return nil
        }
        return self[index]
    }
}
