//
//  LocalStorage.swift
//  RepoSearch
//
//  Created by Sergey Blinov on 11/13/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

protocol KeyValueStore {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String) -> Void
    func removeObject(forKey defaultName: String) -> Void
}

extension UserDefaults : KeyValueStore {}

class LocalStorage {
    static let shared = LocalStorage()

    let keyValueStore : KeyValueStore

    init(keyValueStore: KeyValueStore = UserDefaults.standard) {
        self.keyValueStore = keyValueStore
    }
    
    var gitItems: [GitRepo]? {
        get {
            guard let placesData = keyValueStore.object(forKey: REPO_ITEMS) as? Data,
                let placesArray = NSKeyedUnarchiver.unarchiveObject(with: placesData) as? [GitRepo]
                else { return nil }
            
            return placesArray
        }
        set {
            let placesData = NSKeyedArchiver.archivedData(withRootObject: newValue as Any)
            keyValueStore.set(placesData, forKey: REPO_ITEMS)
        }
    }

    func clearItems() {
        keyValueStore.removeObject(forKey: REPO_ITEMS)
    }

}
