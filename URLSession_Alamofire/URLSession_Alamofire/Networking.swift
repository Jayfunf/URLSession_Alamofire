//
//  Networking.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/28.
//

import Foundation
import Alamofire
import Combine

class networkingClass: ObservableObject {
    let url = "https://randomuser.me/api/?results=50&inc=name,email,picture"
    
    var dataWithURLSession: [UserDatas] = []
    var dataWithAlamofire: [UserDatas] = []
    
    func urlSessionNetworking() {
        
    }

    func alamofireNetworking() {
        
    }
}


