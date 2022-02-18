//
//  NetworkServiceProxy.swift
//  VK
//
//  Created by Михаил Киржнер on 18.02.2022.
//

class NetworkServiceProxy: NetworkServiceProtocol {

     var networkService: NetworkServices

     init(_ base: NetworkServices){
         self.networkService = base
     }

     func getFriends(completion: @escaping ([FriendDAO]) -> Void) {
         networkService.getFriends(completion: completion)
         printLog(method: "getFriends")
     }

     func getPhotos(ownerId: Int, completion: @escaping ([PhotoFriend]) -> Void) {
         networkService.getPhotos(ownerId: ownerId, completion: completion)
         printLog(method: "getPhotos")
     }

     func getGroups(completion: @escaping ([GroupDAO]) -> Void) {
         networkService.getGroups(completion: completion)
         printLog(method: "getGroups")
     }

     func searchGroups(query: String, completion: @escaping ([GroupDAO]) -> Void) {
         networkService.searchGroups(query: query, completion: completion)
         printLog(method: "networkService")
     }

     func joinToGroup(groupId: Int, completion: @escaping (Int) -> Void) {
         networkService.joinToGroup(groupId: groupId, completion: completion)
         printLog(method: "joinToGroup")
     }

     func leaveGroup(groupId: Int, completion: @escaping (Int) -> Void) {
         networkService.leaveGroup(groupId: groupId, completion: completion)
         printLog(method: "leaveGroup")
     }

     func getNews(startFrom: String? = nil, completion: @escaping (NewsResponseDTO) -> Void) {
         networkService.getNews(startFrom: startFrom, completion: completion)
         printLog(method: "getNews")
     }


     private func printLog(method: String){
         print("Proxy Log networkService method: " + method )
     }
 }
