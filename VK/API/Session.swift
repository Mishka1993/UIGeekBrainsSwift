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
//    var token: String {
//        set{
//            KeychainWrapper.standard.set(newValue, forKey: "com.VKClien334.token")
//        }
//        get{
//            KeychainWrapper.standard.string(forKey: "com.VKClien334.token") ?? ""
//        }
//    }
//    var userId: Int {
//        set{
//            KeychainWrapper.standard.set(newValue, forKey: "com.VKClien334.token")
//        }
//        get{
//            KeychainWrapper.standard.integer(forKey: "com.VKClien334.token") ?? 0
//        }
//    }
}
