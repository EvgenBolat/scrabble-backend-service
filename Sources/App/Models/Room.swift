import Vapor
import FluentSQL

extension GamingRoom {
    
    func kickParticipant(userId: UUID) {
        //
        participants.removeAll { $0.id == userId }
    }

    func startGame() {
        //
    }

    func pauseGame() {
        //
    }

    func closeRoom() {
        //
    }

    func addWord(word: String, playerId: UUID) -> Bool {
        //
        return true 
    }
}

struct LeaderboardEntry: Content {
    var playerId: UUID
    var nickname: String
    var score: Int
}

final class Room: Model {
    static let schema = "gamingRooms"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "adminId")
    var adminId: UUID

    @Field(key: "inviteCode")
    var inviteCode: String

    @Children(for: \.$room)
    var participants: [User] // User - another model

    @Field(key: "leaderboard")
    var leaderboard: [LeaderboardEntry]

    @Field(key: "boardState")
    var boardState: [[String]]

    @Field(key: "remainingTilesNum") // number of remaining tiles
    var remainingTilesNum: Int

    @Field(key: "playerTiles") // tiles that belong to this player now
    var playerTiles: [UUID: [String]] // player id - tiles

    init() {}

    init(id: UUID? = nil, adminId: UUID, inviteCode: String, leaderboard: [LeaderboardEntry], boardState: [[String]], remainingTilesNum: Int, playerTiles: [UUID: [String]]) {
        self.id = id
        self.adminId = adminId
        self.inviteCode = inviteCode
        self.leaderboard = leaderboard
        self.boardState = boardState
        self.remainingTilesNum = remainingTilesNum
        self.playerTiles = playerTiles
    }
}
