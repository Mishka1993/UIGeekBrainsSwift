//
//  NetworkServices.swift
//  VK
//
//  Created by Екатерина on 15.12.2021.
//

import Foundation
import Alamofire

class NetworkServices {
    
    let url = "https://api.vk.com"
    let versionApi = "5.131"
    
    func getFriends() {
        
        let uri = url + "/method/friends.get"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "order": "hints",
            "count": 5000,
            "fields": "nickname,bdate,city,country,photo_50,online"
        ]
        AF.request(uri, method: .get, parameters: parameters).responseJSON { (json) in
                    print(json)
                   }
    }
    
    func getPhotos() {
        
        let uri = url + "/method/photos.getAll"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "extended": "1"
        ]
        AF.request(uri, method: .get, parameters: parameters).responseJSON { (json) in
                    print(json)
                   }
    }
    
    func getGroups() {
        
        let uri = url + "/method/groups.get"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "extended": "1"
        ]
        AF.request(uri, method: .get, parameters: parameters).responseJSON { (json) in
                    print(json)
                   }
    }
    
    func searchGroups(_ name: String) {
        
        let uri = url + "/method/groups.search"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "q": name,
        ]
        
        AF.request(uri, method: .get, parameters: parameters).responseJSON { (json) in
                    print(json)
                   }
    }
    
}
