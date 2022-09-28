//
//  AlamofireView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/29.
//

import SwiftUI

struct AlamofireView: View {
    @ObservedObject var networking = networkingClass()
    
    init() {
        networking.alamofireNetworking()
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
