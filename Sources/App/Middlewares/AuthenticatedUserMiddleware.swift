//
//  AuthenticatedUserMiddleware.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 06.11.2024.
//

import Vapor
import Fluent
import JWT

struct AuthenticatedUserMiddleware: AsyncMiddleware {
    func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        if req.method == .POST && (req.url.path == "/user/register" || req.url.path == "/user/login") {
            return try await next.respond(to: req)
        }

        do{
            let payload = try req.jwt.verify(as: AuthorizationPayload.self)
            guard let user = try await User.find(payload.userID, on: req.db) else {
                throw Abort(.unauthorized, reason: req.url.path)
            }
            req.auth.login(user)
            return try await next.respond(to: req)
        }
        catch is JWTError {
            guard let token = req.headers.bearerAuthorization?.token else {
                throw Abort(.unauthorized, reason: "No token")
            }
            let session =  try await Session.query(on: req.db).filter(\.$token == token).first()
            if let session {
                try await session.delete(on: req.db)
            }
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
    }
}
