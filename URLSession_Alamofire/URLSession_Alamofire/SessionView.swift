//
//  SessionView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/29.
//

import SwiftUI

struct SessionView: View {
    @ObservedObject var networking = networkingClass()
    let url = "https://randomuser.me/api/?results=50&inc=name,email"
    
    init() {
        networking.urlSessionNetworking(url: url)
    }
    
    var body: some View {
        List(networking.randomUser) { datas in
            ListView(datas)
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
