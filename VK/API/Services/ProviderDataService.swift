//
//  ProviderDataService.swift
//  VK
//
//  Created by Михаил Киржнер on 10.02.2022.
//

import Foundation
import RealmSwift
import PromiseKit

class ProviderDataService {
    let networkService = NetworkServices()
    let syncTimeout = 60.0

    func loadFriends() {
      
        if checkSync(forKey: "friend") {
            let promiseData = FetchDataFriendPromise()
            promiseData.getFriends()
                .done { resp in
                    let realmFriend = try? RealmService.load(typeOf: RealmFriend.self)
                    let friendResult = resp.map { RealmFriend(friend: $0) }
                    .filter { item in
                        if realmFriend?.contains(where: { $0.userId == item.userId }) ?? true {
                            return false
                        }
                        return true
                    }
                
                try RealmService.save(items: friendResult)
                
            }.catch { error in
                print("error RealmFriend: ", error.localizedDescription)
            }
        }
    }

    func loadGroups() {
        if checkSync(forKey: "group") {
            let realmGroup = try? RealmService.load(typeOf: RealmGroup.self)
            let operationQ = OperationQueue()
            operationQ.maxConcurrentOperationCount = 10

            let fetchOperation = FetchDataGroupOperation()
            let parseOperation = ParseDataGroupOperation()
            let saveOperation = SaveDataGroupOperation(realmGroup: realmGroup)

            parseOperation.addDependency(fetchOperation)
            saveOperation.addDependency(parseOperation)

            operationQ.addOperation(fetchOperation)
            operationQ.addOperation(parseOperation)
            operationQ.addOperation(saveOperation)

            saveOperation.completionBlock = {
                print("Save group success! Status: \(saveOperation.state)")
            }
        }
    }

    // MARK: Удаление группы
    func leaveGroup(group: RealmGroup) {
        networkService.leaveGroup(
            groupId: Int(group.groupId)
        ) { codeResp in
            if codeResp == 1 {
                let objectsToDelete = try? RealmService.load(typeOf: RealmGroup.self)
                    .filter("groupId = %f", group.groupId)

                guard let item = objectsToDelete else { return }
                try? RealmService.delete(object: item)
            }
        }
    }
    
    func joinToGroup(group: GroupDAO) {
        networkService.joinToGroup(groupId: Int(group.id)) { codeResp in
            if codeResp == 1 {
                try? RealmService.save(items: [RealmGroup(group: group)])
            }
        }
    }

    private func checkSync(forKey: String) -> Bool {
        let timestamp = NSDate().timeIntervalSince1970
        let lastSync = UserDefaults.standard.double(forKey: forKey)
        if !(lastSync < (timestamp - syncTimeout)) {
            return false
        }
        UserDefaults.standard.set(timestamp, forKey: forKey)
        return true
    }
}
