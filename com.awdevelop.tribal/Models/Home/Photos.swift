//
//  Photos.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 08/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - PhotoElement
struct PhotoElement: Codable {
    let id: String
    let urls: Urls
    let likes: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
        case user
    }
}

// MARK: - Urls
struct Urls: Codable {
    let regular: String
}

// MARK: - User
struct User: Codable {
    let id: String
    let username: String
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let medium: String
}

typealias Photos = [PhotoElement]

// MARK: Initializers
extension PhotoElement {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(PhotoElement.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Alamofire response handlers
extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try JSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responsePhoto(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Photos>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
