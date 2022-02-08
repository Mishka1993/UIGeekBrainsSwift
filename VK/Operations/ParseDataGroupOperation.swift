//
//  ParseDataGroupOperation.swift
//  VK
//
//  Created by Михаил Киржнер on 06.02.2022.
//

import Foundation

final class ParseDataGroupOperation: AsyncOperation {
    var groupDataResponce: VKResponse<GroupItems>?

    override func main() {
        guard
            !isCancelled,
            let fetchOperation = dependencies.first as? FetchDataGroupOperation,
            let responceData = fetchOperation.jsonGroupDataResponce
        else {
            state = .finished
            return
        }

        do {
            groupDataResponce = try JSONDecoder()
                .decode(VKResponse<GroupItems>.self, from: responceData)
            state = .finished
        } catch {
            print("Что-то пошло не так c JSONDecoder!: ", error.localizedDescription)
        }
    }
}

