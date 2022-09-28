//
//  ListView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/28.
//

import SwiftUI

struct ListView: View {
    
    @State var thumbnailImg: Image
    @State var name: String
    @State var email: String
    
    var body: some View {
        HStack {
            thumbnailImg.padding()
            VStack(alignment: .leading){
                Text("\(self.name)")
                Text("\(self.email)")
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(thumbnailImg: Image(systemName: "heart"), name: "Minion", email: "simh3077@gmail.com")
    }
}
