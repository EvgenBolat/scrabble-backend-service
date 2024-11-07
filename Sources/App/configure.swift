import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.jwt.signers.use(.hs256(key: "secret"))
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "jekosmoi1208",
        database: Environment.get("DATABASE_NAME") ?? "scrabble",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
    app.migrations.add(CreateUserTable())
    app.migrations.add(CreateSessionTable())
    try await app.autoMigrate().get()
    app.middleware.use(AuthenticatedUserMiddleware())
    try routes(app)
}
