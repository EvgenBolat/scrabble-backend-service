//
//  UserTokenDTO.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//

import Vapor

struct UserTokenDTO: Content {
    let token: String

    init(token: String) {
        self.token = token
    }
}
