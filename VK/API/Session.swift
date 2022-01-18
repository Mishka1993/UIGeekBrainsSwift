//
//  UserSession.swift
//  VK
//
//  Created by Екатерина on 09.12.2021.
//

import Foundation
import SwiftKeychainWrapper

final class Session {
    private init() {}

         static let instance = Session()

         var token: String {
                 set {
                     KeychainWrapper.standard.set(newValue, forKey: "com.MK.MikhailKirzhnerUI.VK")
                 }
                 get {
                     return KeychainWrapper.standard.string(forKey: "com.MK.MikhailKirzhnerUI.VK") ?? ""
                 }
             }

             var userId: String {
                 set {
                     KeychainWrapper.standard.set(newValue, forKey: "user.Id")
                 }
                 get {
                     return KeychainWrapper.standard.string(forKey: "user.Id") ?? ""
                 }
             }

             var expiresIn = ""

}
