//
//  Session.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 06.11.2024.
//

import Vapor
import FluentSQL

final class Session: Model {
    static let schema = "sessions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "token")
    var token: String


    init() {}

    init(id: UUID? = nil, userID: UUID, token: String) {
        self.id = id
        self.$user.id = userID
        self.token = token
    }
}
