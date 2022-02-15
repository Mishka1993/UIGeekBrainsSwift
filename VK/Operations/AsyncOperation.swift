//
//  AsyncOperation.swift
//  VK
//
//  Created by Михаил Киржнер on 06.02.2022.
//

import Foundation

open class AsyncOperation: Operation {
    public enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            "is" + rawValue.capitalized
        }
    }

    public var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
}

extension AsyncOperation {
    override open var isAsynchronous: Bool {
        true
    }

    override open var isReady: Bool {
        super.isReady && state == .ready
    }

    override open var isExecuting: Bool {
        state == .executing
    }

    override open var isFinished: Bool {
        state == .finished
    }

    override open func start() {
        if isCancelled {
            state = .finished
        } else {
            main()
            state = .executing
        }
    }

    override open func cancel() {
        super.cancel()
        state = .finished
    }
}

