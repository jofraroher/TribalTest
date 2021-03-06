//
//  HomeViewModel.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation

class HomeViewModel {
    
    private var photo = Photos() {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var isLoading: Bool = true {
        didSet { self.updateLoadingStatus?() }
    }
    
    private var dataService: DataService?
    
    // MARK: - Closures for callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    private var pageNumber: Int = 1
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network call
    func fetchPhoto() {
        self.isLoading = true
        self.dataService?.requestFetchPhoto(pageNumber: pageNumber, completion: { (photos, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.isLoading = false
            self.photo.append(contentsOf: photos!)
            self.pageNumber += 1
        })
    }
}

extension HomeViewModel {
    
    func homeListViewModel(at index: Int) -> PhotoElement? {
        return self.photo[index]
    }
    
    func numberOfItems() -> Int? {
        self.photo.count
    }
}
