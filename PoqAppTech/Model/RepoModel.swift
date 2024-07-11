//
//  RepoModel.swift
//  PoqAppTech
//
//  Created by Екатерина Лаптева on 10.07.24.
//

import Foundation

struct RepoModel: Decodable, Equatable {
    let name: String
    let description: String?
    let owner: Owner
}

struct Owner: Decodable, Equatable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}

