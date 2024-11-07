import Vapor

func routes(_ app: Application) throws {
    let userController = UserController()
    try app.register(collection: userController)
}
