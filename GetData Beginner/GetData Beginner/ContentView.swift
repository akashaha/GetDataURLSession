//
//  ContentView.swift
//  GetData Beginner
//
//  Created by Arman Akash on 7/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var user : GitHubUsers?
    private var defultValue: Double = 0
    var body: some View {
        VStack(spacing: 20){
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                     .foregroundColor(.secondary)
                     
            }
            .frame(width: 120, height: 120)

           
            HStack {
                Text(user?.login ?? "Login Placeholder")
                    .bold()
                .font(.title3)
                
                Text("\(Int(Double(user? .id ?? 0)))")
            }
            
            Text(user?.bio ?? "Bio Placeholder")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            do{
                user =  try await getUser()
            } catch GHError.invalidURL{
                print("Invalid URL")
            }
            catch GHError.invalidResponse{
                print("Invalid Response")
            }
            catch GHError.invalidData{
                print("Invalid Data")
            }
            catch{
                print("Unexpected Error")
            }
        }
    }
    
    func getUser() async throws -> GitHubUsers{
        
        // crate URLHd
        let endPoint = "https://api.github.com/users/twostraws"
        
        guard let url = URL(string: endPoint) else {
            throw GHError.invalidURL
            
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do{
            let decoder =  JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUsers.self, from: data)
        }catch{
            throw GHError.invalidData
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum GHError : Error  {
case invalidURL
case invalidResponse
case invalidData
}
