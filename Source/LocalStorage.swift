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
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Data else { return nil }
            do {
                let products = try PropertyListDecoder().decode([GitRepo].self, from: data)
                return products
            } catch {
                print("Retrieve Failed")
                return nil
            }
        }
        set {
            do {
                let data = try PropertyListEncoder().encode(newValue)
                let success = NSKeyedArchiver.archiveRootObject(data, toFile: filePath)
                print(success ? "Successful save" : "Save Failed")
            } catch {
                print("Save Failed")
            }
        }
    }
    
    func clearItems() {
        try? FileManager.default.removeItem(atPath: filePath)
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent(REPO_ITEMS).path)
    }
    
}
