//
//  UserController.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//

import Vapor
import Fluent
import JWT

//struct UserController: RouteCollection {
//    
//    func boot(routes: RoutesBuilder) throws {
//        let users = routes.grouped("users")
//        users.post("register", use: register)
//        users.post("login", use: login)
//    }
//
//    @Sendable func login(req: Request) async throws -> UserTokenDTO {
//        let loginData = try req.content.decode(LoginDTO.self)
//        guard let user = try await User.query(on: req.db).filter(\.$email == loginData.email).first() else {
//            throw Abort(.unauthorized, reason: "Invalid email")
//        }
//
//        if try Bcrypt.verify(loginData.password, created: user.passwordHash) {
//            let payload = try generateToken(for: user, req: req)
//            let token = try req.jwt.sign(payload)
//            return UserTokenDTO(token: token)
//        } else {
//            throw Abort(.unauthorized, reason: "Invalid password")
//        }
//    }
//
//    func generateToken(for user: User, req: Request) throws -> AuthorizationPayload {
//        let expirationTime = Date().addingTimeInterval(60 * 60)
//        return AuthorizationPayload(userID: try user.requireID(), expiration: ExpirationClaim(value: expirationTime))
//    }
//
//    @Sendable func register(req: Request) async throws -> UserDTO {
//        let registerData = try req.content.decode(RegisterDTO.self)
//
//        guard try await User.query(on: req.db).filter(\.$email == registerData.email).first() == nil else {
//            throw Abort(.badRequest, reason: "User with this email already exists.")
//        }
//
//        let passwordHash = try Bcrypt.hash(registerData.password)
//
//        let user = User(email: registerData.email, passwordHash: passwordHash)
//        try await user.save(on: req.db)
//
//        return UserDTO(id: user.id, email: user.email)
//    }
//}
//
//struct AuthenticatedUserMiddleware: AsyncMiddleware {
//    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
//        let payload = try req.jwt.verify(as: AuthorizationPayload.self)
//        guard let user = try await User.find(payload.userID, on: req.db) else {
//            throw Abort(.unauthorized)
//        }
//        req.auth.login(user)
//        return try await next.respond(to: req)
//    }
//}
