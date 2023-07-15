//
//  Model.swift
//  GetData Beginner
//
//  Created by Arman Akash on 7/13/23.
//

import Foundation

struct GitHubUsers : Codable{
    let login : String
    let id: Int
    let avatarUrl : String
    let bio : String
}
