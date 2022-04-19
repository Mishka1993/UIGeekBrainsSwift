//
//  AppSettings.swift
//  VK
//
//  Created by Михаил Киржнер on 28.03.2022.
//

import Foundation
import UIKit
class AppSettings {
    static let instance = AppSettings()
    let apiService = NetworkServices()
    let apiAdapter = APIAdapter()
    let photoService = PhotoService(container: UITableView())
}
