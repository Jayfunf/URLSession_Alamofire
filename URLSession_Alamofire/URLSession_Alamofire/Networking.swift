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
    let url = "https://randomuser.me/api/?results=50&inc=name,email"
    
    @Published var randomUser = [RandomUser]()
    
    func urlSessionNetworking() {
        guard let sessionUrl = URL(string: url) else { return }
        let session = URLSession(configuration: .default)
        
        var requestURL = URLRequest(url: sessionUrl)
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                do {
                    let decodedData = try JSONDecoder().decode(UserDatas.self, from: safeData)
                    self.randomUser = decodedData.results
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }

    func alamofireNetworking() {
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .validate()
            .responseDecodable (of: UserDatas.self) { response in
                switch response.result {
                case .success(let value):
                    self.randomUser = value.results
                    print(value.results)
                case .failure(let error):
                    print(error)
                }
            }
    }
}


