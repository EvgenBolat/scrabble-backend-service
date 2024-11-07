//
//  Register.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//

import Vapor

struct RegisterDTO: Content {
    let email: String
    let password: String
    let name: String

    init(email: String, password: String, name: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}
