//
//  NetworkServiceProtocol.swift
//  VK
//
//  Created by Михаил Киржнер on 18.02.2022.
//

import Foundation

protocol NetworkServiceProtocol {
     func getFriends(completion: @escaping ([FriendDAO]) -> Void)
     func getPhotos(ownerId: Int, completion: @escaping ([PhotoFriend]) -> Void)
     func getGroups(completion: @escaping ([GroupDAO]) -> Void)
     func searchGroups(query: String, completion: @escaping ([GroupDAO]) -> Void)
     func joinToGroup(groupId: Int, completion: @escaping (Int) -> Void)
     func leaveGroup(groupId: Int, completion: @escaping (Int) -> Void)
     func getNews(startFrom: String?, completion: @escaping (NewsResponseDTO) -> Void)
 }
