//
//  LocalStorage.swift
//  RepoSearch
//
//  Created by Sergey Blinov on 11/13/18.
//  Copyright © 2018 Sergey Blinov. All rights reserved.
//

import Foundation

extension UserDefaults : KeyValueStore {}

protocol KeyValueStore {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String) -> Void
    func removeObject(forKey defaultName: String) -> Void
}

class LocalStorage {
    static let shared = LocalStorage()
    
    var keyValueStore: KeyValueStore
    var fileManager: FileManager
    
    init(keyValueStore: KeyValueStore = UserDefaults.standard, fileManger: FileManager = FileManager.default) {
        self.keyValueStore = keyValueStore
        self.fileManager = fileManger
    }
    
    var gitItems: [GitRepo]? {
        get {
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: repoItemsFilePath) as? Data else { return nil }
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
                let success = NSKeyedArchiver.archiveRootObject(data, toFile: repoItemsFilePath)
                print(success ? "Successful save" : "Save Failed")
            } catch {
                print("Save Failed")
            }
        }
    }
    
    func clearItems() {
        try? fileManager.removeItem(atPath: repoItemsFilePath)
    }
    
    var repoItemsFilePath: String {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REPO_ITEMS).path
    }
}
