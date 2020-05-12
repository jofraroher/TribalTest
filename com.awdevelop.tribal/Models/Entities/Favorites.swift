//
//  Favorites.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class FavoriteItem: Object {
    
    enum Property: String {
        case id, username, likes, profileImage, photo, isCompleted
    }
    
    dynamic var id = ""
    dynamic var username = ""
    dynamic var likes = 0
    dynamic var profileImage = ""
    dynamic var photo = ""
    dynamic var isCompleted = false
    
    override static func primaryKey() -> String? {
        return FavoriteItem.Property.id.rawValue
    }
    
    convenience init(_ id: String, _ username: String, _ likes: Int, _ profileImage: String, _ photo: String) {
        self.init()
        self.id = id
        self.username = username
        self.likes = likes
        self.profileImage = profileImage
        self.photo = photo
    }
}

// MARK: - CRUD methods

extension FavoriteItem {
    
    static func all(in realm: Realm = try! Realm()) -> Results<FavoriteItem> {
        return realm.objects(FavoriteItem.self)
            .sorted(byKeyPath: FavoriteItem.Property.isCompleted.rawValue)
    }
    
    static func existObject(id: String, in realm: Realm = try! Realm()) -> FavoriteItem? {
        return realm.object(ofType: FavoriteItem.self, forPrimaryKey: id)
    }
    

  @discardableResult
    static func add(id: String, username: String, likes: Int, profileImage: String, photo: String, in realm: Realm = try! Realm())
    -> FavoriteItem {
      let item = FavoriteItem(id, username, likes, profileImage, photo)
      try! realm.write {
        realm.add(item)
      }
      return item
  }

  func toggleCompleted() {
    guard let realm = realm else { return }
    try! realm.write {
      isCompleted = !isCompleted
    }
  }

  func delete() {
    guard let realm = realm else { return }
    try! realm.write {
      realm.delete(self)
    }
  }
    
    static func deleteItem(id: String) -> Bool {
        let realm = try! Realm()
        if let userObject = realm.object(ofType: FavoriteItem.self, forPrimaryKey: id) {
            try! realm.write {
            realm.delete(userObject)
            }
            return true
        }else {
            return false
        }
    }
}
