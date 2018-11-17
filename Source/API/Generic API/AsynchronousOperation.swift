//
//  AsynchronousOperation.swift
//  Generik API Client
//
//  Created by Sergey on 11/17/18.
//  Copyright © 2018 sblinov.com. All rights reserved.
//

import Foundation

class AsynchronousOperation: Operation {
    
    enum State {
        case ready, executing, finished, cancelled
        fileprivate var keyPath: String {
            switch self {
            case .ready: return #keyPath(Operation.isReady)
            case .executing: return #keyPath(Operation.isExecuting)
            case .finished: return #keyPath(Operation.isFinished)
            case .cancelled: return #keyPath(Operation.isCancelled)
            }
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }

    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .cancelled
        } else {
            main()
            state = .executing
        }
    }
}
