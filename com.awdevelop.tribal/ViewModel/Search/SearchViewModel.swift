//
//  SearchViewModel.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    // MARK: - Properties
    var searchResult: SearchList? {
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
    
    var pageNumber: Int = 1
    
    // MARK: - Closures for callback, since we are not using the ViewModel to the View.
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    // MARK: - Network call
    func fetchUser(pageIndex: Int, username: String) {
        self.dataService?.requestSearch(pageIndex: pageNumber, query: username, completion: { (search, error) in
            if let error = error {
                self.error = error
                self.isLoading = false
                return
            }
            self.error = nil
            self.pageNumber += 1
            self.isLoading = false
            self.searchResult = search
        })
    }
}
