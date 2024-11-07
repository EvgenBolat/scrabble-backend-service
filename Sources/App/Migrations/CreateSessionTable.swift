//
//  CreateSessionTable.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 06.11.2024.
//


import Vapor
import Fluent

struct CreateSessionTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sessions")
            .id()
            .field("user_id", .uuid, .required, .references("users", "id"))
            .field("token", .string, .required)
            .unique(on: "user_id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("sessions").delete()
    }
}
