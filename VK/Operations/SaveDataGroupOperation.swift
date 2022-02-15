//
//  SaveDataGroupOperation.swift
//  VK
//
//  Created by Михаил Киржнер on 06.02.2022.
//

import Foundation
import RealmSwift

final class SaveDataGroupOperation: AsyncOperation {
    var realmGroup: Results<RealmGroup>?

    init(realmGroup: Results<RealmGroup>?) {
        self.realmGroup = realmGroup
        super.init()
    }

    override func main() {
        guard
            !isCancelled,
            let parseOperation = dependencies.first as? ParseDataGroupOperation,
            let responceData = parseOperation.groupDataResponce
        else {
            state = .finished
            return
        }

        OperationQueue.main.addOperation {
            do {
                let groupResult = responceData.response.items.map { RealmGroup(group: $0) }
                    .filter { item in
                        if self.realmGroup?.contains(where: { $0.groupId == item.groupId }) ?? true {
                            return false
                        }
                        return true
                    }

                try RealmService.save(items: groupResult)
                self.state = .finished
            } catch {
                print("error RealmGroup: ", error)
            }
        }
    }
}
