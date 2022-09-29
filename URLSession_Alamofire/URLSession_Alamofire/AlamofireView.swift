//
//  AlamofireView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/29.
//

import SwiftUI

struct AlamofireView: View {
    @ObservedObject var networking = networkingClass()
    let url = "https://randomuser.me/api/?results=50&inc=name,email"
    
    init() {
        networking.alamofireNetworking(url: url)
    }
    
    var body: some View {
        List(networking.randomUser) { datas in
            ListView(datas)
        }
    }
}

struct AlamofireView_Previews: PreviewProvider {
    static var previews: some View {
        AlamofireView()
    }
}
