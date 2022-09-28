//
//  ContentView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var networking = networkingClass()
    
    var body: some View {
        List() {
            ListView(thumbnailImg: <#T##Image#>, name: <#T##String#>, email: <#T##String#>)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
