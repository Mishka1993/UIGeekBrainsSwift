//
//  NetworkServices.swift
//  VK
//
//  Created by Екатерина on 15.12.2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit
import RealmSwift


class NetworkServices: NetworkServiceProtocol {
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
    
    func getPhotos(ownerId owner_id: Int, completion completionHandler: @escaping ([PhotoFriend]) -> Void) {
        
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
    
    func getNews(startFrom: String? = nil, completion: @escaping (NewsResponseDTO) -> Void) {
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
        var nextFrom = ""

        vkRequest(url: url) { resp in
            DispatchQueue.global().async(group: dispGroup) {
                do {
                    newsList = try JSONDecoder()
                        .decode(VKResponse<NewsItems>.self, from: resp).response

                    newsProfile = try JSONDecoder()
                        .decode(VKResponse<NewsProfiles>.self, from: resp).response

                    newsGroup = try JSONDecoder()
                        .decode(VKResponse<NewsGroups>.self, from: resp).response
                    nextFrom = try JSONDecoder()
                                            .decode(VKResponse<NewsNextFrom>.self, from: resp).response.nextFrom

                } catch {
                    print("getNews: Что-то пошло не так c JSONDecoder!", error.localizedDescription)
                }
            }

            dispGroup.notify(queue: .main) {
                completion(NewsResponseDTO(
                    newsItems: newsList,
                    groupItems: newsGroup,
                    profileItems: newsProfile,
                    nextFrom: nextFrom
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

    func searchGroups(query: String,
                      completion: @escaping ([GroupDAO]) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.search",
            params: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "count", value: "30"),
                URLQueryItem(name: "fields", value: "description"),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let groupList = try JSONDecoder()
                    .decode(VKResponse<GroupItems>.self, from: resp)
                completion(groupList.response.items)
            } catch {
                print("searchGroups: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    func joinToGroup(groupId: Int,
                     completion: @escaping (Int) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.join",
            params: [
                URLQueryItem(name: "group_id", value: String(groupId)),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let vkResp = try JSONDecoder()
                    .decode(VKResponse<Int>.self, from: resp)
                completion(vkResp.response)
            } catch {
                print("joinToGroup: Что-то пошло не так c JSONDecoder!")
            }
        }
    }

    func leaveGroup(groupId: Int,
                    completion: @escaping (Int) -> Void)
    {
        guard let url = prepareUrl(
            methodName: "groups.leave",
            params: [
                URLQueryItem(name: "group_id", value: String(groupId)),
            ]
        )
        else { return }

        vkRequest(url: url) { resp in
            do {
                let vkResp = try JSONDecoder()
                    .decode(VKResponse<Int>.self, from: resp)
                completion(vkResp.response)
            } catch {
                print("leaveGroup: Что-то пошло не так c JSONDecoder!")
            }
        }
    }
}

extension NetworkServices {
    private func apiRequest(request: DataRequest) -> Promise<Data> {
        return Promise<Data> { resolver in
            request
                .resume()
                .validate(statusCode: 200..<201)
                .validate(contentType: ["application/json"])
                .responseData {
                    response in
                    switch response.result {
                    case .success(let value):
                        resolver.fulfill(value)
                    case .failure(let error):
                        resolver.reject(error)
                    }
                }
        }
    }
    
    private func parseUsersResponse(data: Data) -> Promise<[FriendDAO]> {
        return Promise<[FriendDAO]> { resolver in
            do {
                let value = try JSONDecoder().decode(Response<FriendDAO>.self, from: data)
                resolver.fulfill(value.list)
            } catch {
                resolver.reject(error)
            }
        }
    }

    private func realmInsertUser(data: [FriendDAO], dropBefore: Bool) -> Promise<Void> {
        return Promise<Void> { resolver in
            do {
                let realm = try Realm(configuration: RealmService.deleteIfMigration)
                realm.beginWrite()
                if dropBefore {
                    realm.delete([FriendDAO](realm.objects(FriendDAO.self)))
                }
                realm.add(data, update: .all)
                try realm.commitWrite()
                resolver.fulfill(())
            } catch {
                resolver.reject(error)
            }
        }
    }
    
    func getFriendsByPromise(fieldList: [String] = [],
                             offset: Int = 0)
    {
        
        var fields = Set<String>(["photo_50"])
        fields.formUnion(fieldList)
        let parameters: Parameters = [
            "access_token": Session.instance.token,
            "v": versionApi,
            "offset": String(offset),
            "fields": fields.joined(separator: ",")
        ]
        let request = AF.request(
            url + "friends.get",
            method: .get,
            parameters: parameters)

        Promise { result in
            DispatchQueue.global().async {
                self.apiRequest(request: request).pipe(to: result.resolve)
            }
        }.then { data in
            self.parseUsersResponse(data: data)
        }.then { users in
            self.realmInsertUser(data: users, dropBefore: true)
        }.catch { error in
            print("\(error)")
        }
    }
}
