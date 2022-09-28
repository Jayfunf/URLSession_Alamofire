//
//  ContentView.swift
//  URLSession_Alamofire
//
//  Created by Minhyun Cho on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var network = networkingClass()
    
    let gradient: LinearGradient = {
        let colors: [Color] = [.orange, .pink, .purple, .red, .yellow, .cyan]
            return LinearGradient(gradient: Gradient(colors: [colors.randomElement()!, colors.randomElement()!]), startPoint: .center, endPoint: .topTrailing)
        }()
    
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
                    .cornerRadius(10)
                Spacer()
                Divider()
                Text("Click Here👇")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 300, alignment: .leading)
                    
                VStack {
                    Button {
                        network.alamofireNetworking()
                    } label: {
                        NavigationLink("Alamofire"){
                            AlamofireView()
                        }
                        .frame(width: 300)
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                    }
                    Button {
                        network.urlSessionNetworking()
                    } label: {
                        NavigationLink("URLSession"){
                            SessionView()
                        }
                        .frame(width: 300)
                        .padding()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .background(gradient)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
