//
//  UserSession.swift
//  VK
//
//  Created by Екатерина on 09.12.2021.
//

import Foundation

final class Session {
    static let instance = Session()
    
    private init(){ }

    var token: String = ""
    var userId: Int = 0
}
