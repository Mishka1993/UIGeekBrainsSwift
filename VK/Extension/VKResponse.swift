//
//  VKResponse.swift
//  VK
//
//  Created by Михаил Киржнер on 08.02.2022.
//

struct VKResponse<T: Codable> {
    let response: T
}

extension VKResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case response
    }
}
