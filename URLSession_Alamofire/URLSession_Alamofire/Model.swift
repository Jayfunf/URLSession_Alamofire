//
//  Model.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/28.
//

import Foundation

struct UserDatas: Codable {
    var results: [RandomUser]
}

struct RandomUser: Codable {
    let name: Name
    let email: String
    let picture: Picture
    
    struct Name: Codable {
        var title: String
        var first: String
        var last: String
    }
    
    struct Picture: Codable {
        let large: String
        let medium: String
        let thumbnail: String
    }
}
