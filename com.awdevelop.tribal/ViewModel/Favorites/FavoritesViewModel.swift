//
//  FavoritesViewModel.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritesViewModel {
    
    private var items: Results<FavoriteItem>?
    
    init() {}
    
    // MARK: - Realm call
    func fetchFavorites() {
        self.items = FavoriteItem.all()
    }
}

extension FavoritesViewModel {
    
    func favoritesListViewModel(at index: Int) -> FavoriteItem? {
        return self.items?[index]
    }
    
    func numberOfItems() -> Int? {
        self.items?.count
    }
}
