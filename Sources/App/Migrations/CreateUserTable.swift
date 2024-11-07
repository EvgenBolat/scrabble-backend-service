//
//  CreateUserTable.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 06.11.2024.
//

import Vapor
import Fluent

struct CreateUserTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("passwordHash", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
