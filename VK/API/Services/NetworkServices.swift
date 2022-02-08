//
//  NetworkServices.swift
//  VK
//
//  Created by Екатерина on 15.12.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkServices {
    
    let url = "https://api.vk.com/method/"
    let versionApi = "5.131"
    let userId = Session.instance.userId
    let tokin = Session.instance.token
    
    func getFriends(completion: @escaping([FriendDAO])->()) {
        
        let url = url + "friends.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": tokin,
            "v": versionApi,
            "order": "name",
            "count": "100",
            "fields": "nickname,bdate,city,country,photo_50,online"
        ]
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let jsonData = response.data else { return }
            do {
                let itemsData = try JSON(jsonData)["response"]["items"].rawData()
                let friends = try JSONDecoder().decode([FriendDAO].self, from: itemsData)
                completion(friends)
            } catch {
                print(error)
            }
        }
    }
    
    func getPhotos(_ owner_id: Int, completionHandler: @escaping ([PhotoFriend]) -> Void) {
        
        let url = url + "photos.getAll"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "owner_id": owner_id,
            "v": versionApi,
            "photo_sizes": "1",
            "extended": "1",
            "count": "200",
        ]
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                let responseData = json["response"].dictionaryValue
                let items = responseData["items"]?.arrayValue
                let photos = items?.compactMap { PhotoFriend($0) } ?? [PhotoFriend]()
                
                completionHandler(photos)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGroups(completion: @escaping([GroupDAO])->()) {
        
        let url = url + "groups.get"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "count": "1000",
            "extended": "1",
            "fields": "members_count"
        ]
        AF.request(url, method: .get, parameters: parameters).responseData { response in
            guard let jsonData = response.data else { return }
            do {
                let itemsData = try JSON(jsonData)["response"]["items"].rawData()
                let groups = try JSONDecoder().decode([GroupDAO].self, from: itemsData)
                completion(groups)
            } catch {
                print(error)
            }
        }
    }
    
    func searchGroups(_ name: String) {
        
        let url = url + "groups.search"
        
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "q": name,
        ]
        
        AF.request(url, method: .get, parameters: parameters).responseData { (json) in
            print(json)
        }
    }
    
    func getNews(completion: @escaping (NewsResponseDTO) -> Void) {
        guard let url = prepareUrl(
            methodName: "newsfeed.get",
            params: [
                URLQueryItem(name: "count", value: "30"),
                URLQueryItem(name: "filters", value: "post,photo,note"),
                URLQueryItem(name: "fields", value: "first_name,last_name,photo_100,photo_50,description"),
            ]
        )
        else { return }

        let dispGroup = DispatchGroup()
        var newsList = NewsItems(items: [NewsPost]())
        var newsProfile = NewsProfiles(profiles: [FriendDAO]())
        var newsGroup = NewsGroups(groups: [GroupDAO]())

        vkRequest(url: url) { resp in
            DispatchQueue.global().async(group: dispGroup) {
                do {
                    newsList = try JSONDecoder()
                        .decode(VKResponse<NewsItems>.self, from: resp).response

                    newsProfile = try JSONDecoder()
                        .decode(VKResponse<NewsProfiles>.self, from: resp).response

                    newsGroup = try JSONDecoder()
                        .decode(VKResponse<NewsGroups>.self, from: resp).response

                } catch {
                    print("getNews: Что-то пошло не так c JSONDecoder!", error.localizedDescription)
                }
            }

            dispGroup.notify(queue: .main) {
                completion(NewsResponseDTO(
                    newsItems: newsList,
                    groupItems: newsGroup,
                    profileItems: newsProfile
                ))
            }
        }
    }
    
    private let session = URLSession.shared
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        return constructor
    }()
    
    private func prepareUrl(methodName: String, params: [URLQueryItem]?) -> URL? {
        
        urlConstructor.path = "/method/" + methodName
        urlConstructor.queryItems = [
            URLQueryItem(
                name: "user_ids",
                value: String(Session.instance.userId)
            ),
            URLQueryItem(
                name: "access_token",
                value: Session.instance.token
            ),
            URLQueryItem(
                name: "v",
                value: "5.131"
            ),
        ]

        if let p = params {
            for itemParam in p {
                urlConstructor.queryItems?.append(itemParam)
            }
        }

        return urlConstructor.url
    }

    private func vkRequest(url: URL, completion: @escaping (Data) -> Void) {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0

        session.dataTask(with: request) { responseData, urlResponse, error in
            if let response = urlResponse as? HTTPURLResponse {
                print("Код ответа: \(response.statusCode)")
            }
            guard
                error == nil,
                let responseData = responseData
            else { return }
            do {
                DispatchQueue.main.async {
                    completion(responseData)
                }
            } catch {
                print("Ошибка при получении ответа: \(error)")
            }
        }
        .resume()
    }
}

