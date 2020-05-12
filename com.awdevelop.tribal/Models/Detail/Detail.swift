//
//  Detail.swift
//  com.awdevelop.tribal
//
//  Created by Administrador on 11/05/20.
//  Copyright © 2020 Francisco Rosales. All rights reserved.
//

import Foundation
import Alamofire

struct Detail: Codable {
    
    let id: String
    let username, name, firstName: String
    let lastName: String?
    let bio: String?
    let location: String?
    let links: UserLinks
    let profileImage: ProfileImage
    let totalCollections, totalLikes, totalPhotos: Int
    let photos: [Photo]

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio, location, links
        case profileImage = "profile_image"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case photos
    }
    
}

// MARK: - WelcomeLinks
struct UserLinks: Codable {
    let photos: String

    enum CodingKeys: String, CodingKey {
        case photos
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
}

extension Detail {
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(Detail.self, from: data)
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
    func responseUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<Detail>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
