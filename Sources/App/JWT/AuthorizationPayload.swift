//
//  AuthorizationPayload.swift
//  scrabble-backend-service
//
//  Created by Евгений Хавронич on 04.11.2024.
//
import JWT
import Foundation
import Vapor
import Fluent
import JWTKit

struct AuthorizationPayload : JWTPayload {
    var userID: UUID
    var expiration: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }

    init(userID: UUID, expiration: ExpirationClaim) {
        self.userID = userID
        self.expiration = expiration
    }
}
