//
//  UserController.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//

import Vapor
import Fluent
import JWT

struct UserController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        users.post("register", use: register)
        users.post("login", use: login)
        users.post("logout", use: logout)
    }

    @Sendable func login(req: Request) async throws -> UserTokenDTO {
        let loginData = try req.content.decode(LoginDTO.self)
        guard let user = try await User.query(on: req.db).filter(\.$email == loginData.email).first() else {
            throw Abort(.unauthorized, reason: "Invalid email")
        }
        print("ok 1")
        let session = try await Session.query(on: req.db).filter(\.$user.$id == user.requireID()).first()
        if session != nil {
            throw Abort(.unauthorized, reason: "User is already logged in")
        }
        if try Bcrypt.verify(loginData.password, created: user.passwordHash) {
            let payload = try generateToken(for: user, req: req)
            let token = try req.jwt.sign(payload)

            let session = Session(userID: try user.requireID(), token: token)
            try await session.save(on: req.db)

            return UserTokenDTO(token: token)
        } else {
            throw Abort(.unauthorized, reason: "Invalid password")
        }
    }

    func generateToken(for user: User, req: Request) throws -> AuthorizationPayload {
        let expirationTime = Date().addingTimeInterval(60 * 60)
        return AuthorizationPayload(userID: try user.requireID(), expiration: ExpirationClaim(value: expirationTime))
    }

    @Sendable func register(req: Request) async throws -> UserDTO {
        let registerData = try req.content.decode(RegisterDTO.self)

        guard try await User.query(on: req.db).filter(\.$email == registerData.email).first() == nil else {
            throw Abort(.badRequest, reason: "User with this email already exists.")
        }

        let passwordHash = try Bcrypt.hash(registerData.password)

        let user = User(email: registerData.email, name: registerData.name, passwordHash: passwordHash)
        try await user.save(on: req.db)

        return UserDTO(id: user.id, email: user.email)
    }

    @Sendable func logout(req: Request) async throws -> HTTPStatus {
        guard let token = req.headers.bearerAuthorization?.token else{
            throw Abort(.unauthorized, reason: "No token provided.")
        }
        guard let session = try await Session.query(on: req.db).filter(\.$token == token).first() else {
            throw Abort(.badRequest, reason: "Invalid token.")
        }
        try await session.delete(on: req.db)
        return .ok
    }
}
