//
//  DataService.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation
import Alamofire

struct DataService {
    
    // MARK: - Singleton
    static let shared = DataService()
    
    // MARK: - URL
    private var photoUrl = "https://api.unsplash.com/"
    
    // MARK: - Header
    let headers = [
        "Authorization": "Client-ID _rl98FgcPh3S4wqfNOpL3A7ndaR09CBHxgR5pe9vXcE"
    ]
    
    // MARK: - Services
    func requestFetchPhoto(pageNumber: Int, completion: @escaping (Photos?, Error?) -> ()) {
        let url = "\(photoUrl)photos/?per_page=10&page=\(pageNumber)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responsePhoto { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo, nil)
                return
            }
        }
    }
    
    func requestUserInfo(userName: String, completion: @escaping (Detail?, Error?) -> ()) {
        let url = "\(photoUrl)users/\(userName)?per_page=10"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseUser { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo, nil)
                return
            }
        }
    }
    
    // MARK: - Services
    func requestListPhotosUser(url: String, pageIndex: Int, completion: @escaping (Photos?, Error?) -> ()) {
        let url = "\(url)?per_page=10&page=\(pageIndex)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responsePhoto { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo, nil)
                return
            }
        }
    }
    
    func requestSearch(pageIndex: Int, query: String, completion: @escaping (SearchList?, Error?) -> ()) {
        let url = "\(photoUrl)search/users?per_page=40&page=\(pageIndex)&query=\(query)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseSarch { response in
            if let error = response.error {
                completion(nil, error)
                return
            }
            if let photo = response.result.value {
                completion(photo, nil)
                return
            }
        }
    }
}
