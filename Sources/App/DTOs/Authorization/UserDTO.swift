//
//  UserDTO.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//

import Vapor

struct UserDTO: Content {
    let id: UUID?
    let email: String

    init(id: UUID?, email: String) {
        self.id = id
        self.email = email
    }
}
